require 'thread'
require 'leveldb/iterator'
require 'leveldb/batch'
require 'leveldb/snapshot'

module LevelDB
  class DB
    include Enumerable

    class Error < StandardError; end
    class KeyError < StandardError; end
    class ClosedError < StandardError; end

    attr_reader :path, :options
    @@mutex = Mutex.new

    DEFAULT = {
      create_if_missing: true,
      error_if_exists: false,
      paranoid_checks: false,
      write_buffer_size: 4 << 20,
      block_size: 4096,
      max_open_files: 200,
      block_cache_size: 8 * (2 << 20),
      block_restart_interval: 16,
      compression: false,
      verify_checksums: false,
      fill_cache: true
    }

    def initialize(path, options={})
      new!(path, options)
    end

    def new!(path, options={})
      @_db_opts    = C.options_create
      @_write_opts = C.writeoptions_create
      @_read_opts  = C.readoptions_create
      @_read_len   = C.value('size_t')

      @options = DEFAULT.merge(options)

      @_cache = C.cache_create_lru(@options[:block_cache_size])

      C.readoptions_set_verify_checksums(@_read_opts, @options[:verify_checksums] ? 1 : 0)
      C.readoptions_set_fill_cache(@_read_opts, @options[:fill_cache] ? 1 : 0)

      C.options_set_create_if_missing(@_db_opts, @options[:create_if_missing] ? 1 : 0)
      C.options_set_error_if_exists(@_db_opts, @options[:error_if_exists] ? 1 : 0)
      C.options_set_paranoid_checks(@_db_opts, @options[:paranoid_checks] ? 1 : 0)
      C.options_set_write_buffer_size(@_db_opts, @options[:write_buffer_size])
      C.options_set_block_size(@_db_opts, @options[:block_size])
      C.options_set_cache(@_db_opts, @_cache)
      C.options_set_max_open_files(@_db_opts, @options[:max_open_files])
      C.options_set_block_restart_interval(@_db_opts, @options[:block_restart_interval])
      C.options_set_compression(@_db_opts, @options[:compression] ? 1 : 0)

      if @options[:bloom_filter_bits_per_key]
        C.options_set_filter_policy(@_db_opts, C.filterpolicy_create_bloom(@options[:bloom_filter_bits_per_key]))
      end

      @_db_opts.free = @_write_opts.free = @_read_opts.free = C[:options_destroy]

      @path = path

      @_err = C::Pointer.malloc(C::SIZEOF_VOIDP)
      @_err.free = @_read_len.to_ptr.free = C[:free]

      @_db = C.open(@_db_opts, @path, @_err)
      @_db.free = C[:close]

      raise Error, error_message if errors?
    end
    private :new!

    def reopen
      close unless closed?
      @@mutex.synchronize { @_closed = false }
      new!(@path, @options)
    end
    alias reopen! reopen

    def []=(key, val)
      raise ClosedError if closed?

      key = key.to_s
      val = val.to_s

      C.put(@_db, @_write_opts, key, key.bytesize, val, val.bytesize, @_err)

      raise Error, error_message if errors?

      val
    end
    alias put []=

    def [](key)
      raise ClosedError if closed?

      key = key.to_s
      val = C.get(@_db, @_read_opts, key, key.bytesize, @_read_len, @_err)
      val.free = C[:free]

      raise Error, error_message if errors?

      @_read_len.value == 0 ? nil : val.to_s(@_read_len.value).clone
    end
    alias get []

    def delete(key)
      raise ClosedError if closed?

      key = key.to_s
      val = get(key)
      C.delete(@_db, @_write_opts, key, key.bytesize, @_err)

      raise Error, error_message if errors?

      val
    end

    def exists?(key)
      get(key) != nil
    end
    alias includes? exists?
    alias contains? exists?
    alias member?   exists?
    alias has_key?  exists?

    def fetch(key, default=nil, &block)
      val = get(key)

      return val if val
      raise KeyError if default.nil? && !block_given?

      val = block_given? ? block[key] : default
      put(key, val)
    end

    def snapshot
      Snapshot.new(@_db, @_read_opts)
    end

    def batch(&block)
      raise ClosedError if closed?

      batch = Batch.new(@_db, @_write_opts)

      if block_given?
        block[batch]
        batch.write!
      else
        batch
      end
    end

    def close
      raise ClosedError if closed?

      # Prevent double free, I can't free it since
      # after this call we can still `destroy` it.
      @_db.free = nil
      C.close(@_db)
      @@mutex.synchronize { @_closed = true }
      raise Error, error_message if errors?

      true
    end

    def each(&block)
      raise ClosedError if closed?

      iterator = Iterator.new(@_db, @_read_opts, @_read_len)
      iterator.each(&block)
      iterator
    end

    def reverse_each(&block)
      each.reverse_each(&block)
    end

    def range(from, to, &block)
      each.range(from, to, &block)
    end

    def reverse_range(from, to, &block)
      reverse_each.range(from, to, &block)
    end

    def keys
      map { |k, v| k }
    end

    def values
      map { |k, v| v }
    end

    def closed?
      @@mutex.synchronize { @_closed }
    end

    def destroy
      C.destroy_db(@_db_opts, @path, @_err)
      raise Error, error_message if errors?

      true
    end

    def destroy!
      close && destroy && reopen
    end
    alias clear! destroy!

    def read_property(name)
      raise ClosedError if closed?

      C.property_value(@_db, name).to_s
    end

    def stats
      read_property('leveldb.stats')
    end

    def errors?
      return unless @_err
      !@_err.ptr.null?
    end

    def error_message
      return unless errors?
      @_err.ptr.to_s
    ensure
      if errors?
        @_err = C::Pointer.malloc(C::SIZEOF_VOIDP)
        @_err.free = C[:free]
      end
    end
    alias clear_errors! error_message

    def inspect
      "#<LevelDB::DB:#{'0x%x' % object_id}>"
    end
    alias to_s inspect
  end
end
