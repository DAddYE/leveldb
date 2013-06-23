require 'native'
require 'thread'

module LevelDB
  C = Native

  class DB
    include Enumerable

    class Error < StandardError; end
    class ClosedError < StandardError; end

    attr_reader :path
    @@mutex = Mutex.new

    def initialize(path, options={})
      @_db_opts    = C.options_create
      @_write_opts = C.writeoptions_create
      @_read_opts  = C.readoptions_create
      @_read_len   = C.value('size_t')

      C.options_set_create_if_missing @_db_opts, 1

      @_db_opts.free = @_write_opts.free = @_read_opts.free = C[:options_destroy]

      @path = path

      @_err = C::Pointer.malloc(C::SIZEOF_VOIDP)
      @_err.free = @_read_len.to_ptr.free = C[:free]

      @_db = C.open(@_db_opts, @path, @_err)
      @_db.free = C[:close]

      raise Error, error_message if errors?
    end

    def []=(key, val)
      raise ClosedError if closed?

      key = key.to_s
      val = val.to_s

      C.put(@_db, @_write_opts, key, key.size, val, val.size, @_err)

      raise Error, error_message if errors?

      val
    end
    alias put []=

    def [](key)
      raise ClosedError if closed?

      key  = key.to_s
      val  = C.get(@_db, @_read_opts, key, key.size, @_read_len, @_err)

      raise Error, error_message if errors?

      val.null? ? nil : val.to_s(@_read_len.value)
    end
    alias get []

    def delete(key)
      raise ClosedError if closed?

      key = key.to_s
      val = get(key)
      C.delete(@_db, @_write_opts, key, key.size, @_err)

      raise Error, error_message if errors?

      val
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
  end

  class Iterator

    def initialize(db, read_opts, read_len, reverse=false)
      @_db        = db
      @_read_opts = read_opts
      @_read_len  = read_len
      @_reverse   = reverse
      @_err       = C::Pointer.malloc(C::SIZEOF_VOIDP)
      @_err.free  = C[:free]
      @_iterator  = C.create_iterator(@_db, @_read_opts)
      # @_iterator.free = C[:iter_destroy]
      rewind
    end

    def rewind
      if reverse?
        C.iter_seek_to_last(@_iterator)
      else
        C.iter_seek_to_first(@_iterator)
      end
    end

    def reverse_each(&block)
      @_reverse = !@_reverse
      rewind
      each(&block)
    end

    def each(&block)
      return self unless block_given?
      if current = self.next
        block[*current]
      end while valid?
      @_range = nil
    end

    def range(from, to, &block)
      @_range = [from.to_s, to.to_s].sort
      @_range = @_range.reverse if reverse?
      each(&block)
    end

    def next
      while valid? && !in_range?
        move_next
      end if range?

      key, val = current

      return unless key

      [key, val]
    ensure
      move_next
    end

    def peek
      self.next
    ensure
      move_prev
    end

    def valid?
      C.iter_valid(@_iterator) == 1
    end

    def reverse?
      @_reverse
    end

    def range?
      !!@_range
    end

    private
    def current
      return unless valid?

      key = C.iter_key(@_iterator, @_read_len).to_s(@_read_len.value)
      val = C.iter_value(@_iterator, @_read_len).to_s(@_read_len.value)

      [key, val]
    end

    def in_range?
      reverse? ? (current[0] <= @_range[0] && current[0] >= @_range[1]) :
                 (current[0] >= @_range[0] && current[0] <= @_range[1])
    end

    def move_next
      return unless valid?

      if reverse?
        C.iter_prev(@_iterator)
      else
        C.iter_next(@_iterator)
      end
    end

    def move_prev
      return unless valid?

      if reverse?
        C.iter_next(@_iterator)
      else
        C.iter_prev(@_iterator)
      end
    end

    def errors?
      C.iter_get_error(@_iterator, @_err)
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
  end
end
