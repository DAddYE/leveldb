require 'ffi'

module Leveldb
  extend FFI::Library
  ffi_lib File.expand_path("../../ext/leveldb/libleveldb.#{FFI::Platform::LIBSUFFIX}", __FILE__)

  ##
  # Writing FFI::Gen::Enum
  #
  ##
  # Writing FFI::Gen::StructOrUnion
  #
  # (Not documented)
  class T < FFI::Struct
    layout :dummy, :char
  end

  # (Not documented)
  module ComparatorWrappers
    # @return [nil]
    def destroy()
      Leveldb.comparator_destroy(self)
    end
  end

  class Comparator < FFI::Struct
    include ComparatorWrappers
    layout :dummy, :char
  end

  # (Not documented)
  class Filelock < FFI::Struct
    layout :dummy, :char
  end

  # (Not documented)
  class Iterator < FFI::Struct
    layout :dummy, :char
  end

  # (Not documented)
  module OptionsWrappers
    # @param [Comparator] comparator
    # @return [nil]
    def set_comparator(comparator)
      Leveldb.options_set_comparator(self, comparator)
    end

    # @param [Integer] u_char
    # @return [nil]
    def set_create_if_missing(u_char)
      Leveldb.options_set_create_if_missing(self, u_char)
    end

    # @param [Integer] u_char
    # @return [nil]
    def set_paranoid_checks(u_char)
      Leveldb.options_set_paranoid_checks(self, u_char)
    end

    # @param [FFI::Pointer(*Logger)] logger
    # @return [nil]
    def set_info_log(logger)
      Leveldb.options_set_info_log(self, logger)
    end

    # @param [Integer] int
    # @return [nil]
    def set_max_open_files(int)
      Leveldb.options_set_max_open_files(self, int)
    end

    # @param [Integer] u_long
    # @return [nil]
    def set_block_size(u_long)
      Leveldb.options_set_block_size(self, u_long)
    end

    # @param [Integer] int
    # @return [nil]
    def set_compression(int)
      Leveldb.options_set_compression(self, int)
    end

    # @param [FFI::Pointer(*Filterpolicy)] filterpolicy
    # @return [nil]
    def set_filter_policy(filterpolicy)
      Leveldb.options_set_filter_policy(self, filterpolicy)
    end

    # @param [FFI::Pointer(*Env)] env
    # @return [nil]
    def set_env(env)
      Leveldb.options_set_env(self, env)
    end

    # @param [FFI::Pointer(*Cache)] cache
    # @return [nil]
    def set_cache(cache)
      Leveldb.options_set_cache(self, cache)
    end

    # @param [Integer] u_char
    # @return [nil]
    def set_error_if_exists(u_char)
      Leveldb.options_set_error_if_exists(self, u_char)
    end

    # @param [Integer] int
    # @return [nil]
    def set_block_restart_interval(int)
      Leveldb.options_set_block_restart_interval(self, int)
    end

    # @param [Integer] u_long
    # @return [nil]
    def set_write_buffer_size(u_long)
      Leveldb.options_set_write_buffer_size(self, u_long)
    end

    # @return [nil]
    def destroy()
      Leveldb.options_destroy(self)
    end
  end

  class Options < FFI::Struct
    include OptionsWrappers
    layout :dummy, :char
  end

  # (Not documented)
  module ReadoptionsWrappers
    # @param [Integer] u_char
    # @return [nil]
    def set_verify_checksums(u_char)
      Leveldb.readoptions_set_verify_checksums(self, u_char)
    end

    # @param [FFI::Pointer(*Snapshot)] snapshot
    # @return [nil]
    def set_snapshot(snapshot)
      Leveldb.readoptions_set_snapshot(self, snapshot)
    end

    # @param [Integer] u_char
    # @return [nil]
    def set_fill_cache(u_char)
      Leveldb.readoptions_set_fill_cache(self, u_char)
    end

    # @return [nil]
    def destroy()
      Leveldb.readoptions_destroy(self)
    end
  end

  class Readoptions < FFI::Struct
    include ReadoptionsWrappers
    layout :dummy, :char
  end

  # (Not documented)
  class Snapshot < FFI::Struct
    layout :dummy, :char
  end

  # (Not documented)
  module WritebatchWrappers
    # @return [nil]
    def clear()
      Leveldb.writebatch_clear(self)
    end

    # @param [String] key
    # @param [Integer] klen
    # @return [nil]
    def delete(key, klen)
      Leveldb.writebatch_delete(self, key, klen)
    end

    # @return [nil]
    def destroy()
      Leveldb.writebatch_destroy(self)
    end

    # @param [FFI::Pointer(*Void)] state
    # @param [FFI::Pointer(*)] put
    # @param [FFI::Pointer(*)] deleted
    # @return [nil]
    def iterate(state, put, deleted)
      Leveldb.writebatch_iterate(self, state, put, deleted)
    end

    # @param [String] key
    # @param [Integer] klen
    # @param [String] val
    # @param [Integer] vlen
    # @return [nil]
    def put(key, klen, val, vlen)
      Leveldb.writebatch_put(self, key, klen, val, vlen)
    end
  end

  class Writebatch < FFI::Struct
    include WritebatchWrappers
    layout :dummy, :char
  end

  # (Not documented)
  module CacheWrappers
    # @return [nil]
    def destroy()
      Leveldb.cache_destroy(self)
    end
  end

  class Cache < FFI::Struct
    include CacheWrappers
    layout :dummy, :char
  end

  # (Not documented)
  module FilterpolicyWrappers
    # @return [nil]
    def destroy()
      Leveldb.filterpolicy_destroy(self)
    end
  end

  class Filterpolicy < FFI::Struct
    include FilterpolicyWrappers
    layout :dummy, :char
  end

  # (Not documented)
  class Randomfile < FFI::Struct
    layout :dummy, :char
  end

  # (Not documented)
  class Writablefile < FFI::Struct
    layout :dummy, :char
  end

  # (Not documented)
  module EnvWrappers
    # @return [nil]
    def destroy()
      Leveldb.env_destroy(self)
    end
  end

  class Env < FFI::Struct
    include EnvWrappers
    layout :dummy, :char
  end

  # (Not documented)
  class Seqfile < FFI::Struct
    layout :dummy, :char
  end

  # (Not documented)
  class Logger < FFI::Struct
    layout :dummy, :char
  end

  # (Not documented)
  module WriteoptionsWrappers
    # @return [nil]
    def destroy()
      Leveldb.writeoptions_destroy(self)
    end

    # @param [Integer] u_char
    # @return [nil]
    def set_sync(u_char)
      Leveldb.writeoptions_set_sync(self, u_char)
    end
  end

  class Writeoptions < FFI::Struct
    include WriteoptionsWrappers
    layout :dummy, :char
  end

  ##
  # Writing Callbacks
  #
  ##
  # Writing Functions
  #
  # DB operations
  #
  # @method open(options, name, errptr)
  # @param [Options] options
  # @param [String] name
  # @param [FFI::Pointer(**CharS)] errptr
  # @return [T]
  # @scope class
  #
  attach_function :open, :leveldb_open, [Options, :string, :pointer], T

  # (Not documented)
  #
  # @method put(db, options, key, keylen, val, vallen, errptr)
  # @param [T] db
  # @param [Writeoptions] options
  # @param [String] key
  # @param [Integer] keylen
  # @param [String] val
  # @param [Integer] vallen
  # @param [FFI::Pointer(**CharS)] errptr
  # @return [nil]
  # @scope class
  #
  attach_function :put, :leveldb_put, [T, Writeoptions, :string, :ulong, :string, :ulong, :pointer], :void

  # (Not documented)
  #
  # @method write(db, options, batch, errptr)
  # @param [T] db
  # @param [Writeoptions] options
  # @param [Writebatch] batch
  # @param [FFI::Pointer(**CharS)] errptr
  # @return [nil]
  # @scope class
  #
  attach_function :write, :leveldb_write, [T, Writeoptions, Writebatch, :pointer], :void

  # Returns NULL if not found.  A malloc()ed array otherwise.
  #    Stores the length of the array in *vallen.
  #
  # @method create_iterator(db, options)
  # @param [T] db
  # @param [Readoptions] options
  # @return [Iterator]
  # @scope class
  #
  attach_function :create_iterator, :leveldb_create_iterator, [T, Readoptions], Iterator

  # (Not documented)
  #
  # @method release_snapshot(db, snapshot)
  # @param [T] db
  # @param [Snapshot] snapshot
  # @return [nil]
  # @scope class
  #
  attach_function :release_snapshot, :leveldb_release_snapshot, [T, Snapshot], :void

  # Returns NULL if property name is unknown.
  #    Else returns a pointer to a malloc()-ed null-terminated value.
  #
  # @method approximate_sizes(db, num_ranges, range_start_key, range_start_key_len, range_limit_key, range_limit_key_len, sizes)
  # @param [T] db
  # @param [Integer] num_ranges
  # @param [FFI::Pointer(**CharS)] range_start_key
  # @param [FFI::Pointer(*Size)] range_start_key_len
  # @param [FFI::Pointer(**CharS)] range_limit_key
  # @param [FFI::Pointer(*Size)] range_limit_key_len
  # @param [FFI::Pointer(*Uint64)] sizes
  # @return [nil]
  # @scope class
  #
  attach_function :approximate_sizes, :leveldb_approximate_sizes, [T, :int, :pointer, :pointer, :pointer, :pointer, :pointer], :void

  # Management operations
  #
  # @method destroy_db(options, name, errptr)
  # @param [Options] options
  # @param [String] name
  # @param [FFI::Pointer(**CharS)] errptr
  # @return [nil]
  # @scope class
  #
  attach_function :destroy_db, :leveldb_destroy_db, [Options, :string, :pointer], :void

  # Iterator
  #
  # @method iter_destroy(iterator)
  # @param [Iterator] iterator
  # @return [nil]
  # @scope class
  #
  attach_function :iter_destroy, :leveldb_iter_destroy, [Iterator], :void

  # (Not documented)
  #
  # @method iter_seek_to_first(iterator)
  # @param [Iterator] iterator
  # @return [nil]
  # @scope class
  #
  attach_function :iter_seek_to_first, :leveldb_iter_seek_to_first, [Iterator], :void

  # (Not documented)
  #
  # @method iter_seek(iterator, k, klen)
  # @param [Iterator] iterator
  # @param [String] k
  # @param [Integer] klen
  # @return [nil]
  # @scope class
  #
  attach_function :iter_seek, :leveldb_iter_seek, [Iterator, :string, :ulong], :void

  # (Not documented)
  #
  # @method iter_prev(iterator)
  # @param [Iterator] iterator
  # @return [nil]
  # @scope class
  #
  attach_function :iter_prev, :leveldb_iter_prev, [Iterator], :void

  # (Not documented)
  #
  # @method iter_value(iterator, vlen)
  # @param [Iterator] iterator
  # @param [FFI::Pointer(*Size)] vlen
  # @return [String]
  # @scope class
  #
  attach_function :iter_value, :leveldb_iter_value, [Iterator, :pointer], :string

  # Write batch
  #
  # @method writebatch_create()
  # @return [Writebatch]
  # @scope class
  #
  attach_function :writebatch_create, :leveldb_writebatch_create, [], Writebatch

  # (Not documented)
  #
  # @method writebatch_clear(writebatch)
  # @param [Writebatch] writebatch
  # @return [nil]
  # @scope class
  #
  attach_function :writebatch_clear, :leveldb_writebatch_clear, [Writebatch], :void

  # (Not documented)
  #
  # @method writebatch_delete(writebatch, key, klen)
  # @param [Writebatch] writebatch
  # @param [String] key
  # @param [Integer] klen
  # @return [nil]
  # @scope class
  #
  attach_function :writebatch_delete, :leveldb_writebatch_delete, [Writebatch, :string, :ulong], :void

  # Options
  #
  # @method options_create()
  # @return [Options]
  # @scope class
  #
  attach_function :options_create, :leveldb_options_create, [], Options

  # (Not documented)
  #
  # @method options_set_comparator(options, comparator)
  # @param [Options] options
  # @param [Comparator] comparator
  # @return [nil]
  # @scope class
  #
  attach_function :options_set_comparator, :leveldb_options_set_comparator, [Options, Comparator], :void

  # (Not documented)
  #
  # @method options_set_create_if_missing(options, u_char)
  # @param [Options] options
  # @param [Integer] u_char
  # @return [nil]
  # @scope class
  #
  attach_function :options_set_create_if_missing, :leveldb_options_set_create_if_missing, [Options, :uchar], :void

  # (Not documented)
  #
  # @method options_set_paranoid_checks(options, u_char)
  # @param [Options] options
  # @param [Integer] u_char
  # @return [nil]
  # @scope class
  #
  attach_function :options_set_paranoid_checks, :leveldb_options_set_paranoid_checks, [Options, :uchar], :void

  # (Not documented)
  #
  # @method options_set_info_log(options, logger)
  # @param [Options] options
  # @param [Logger] logger
  # @return [nil]
  # @scope class
  #
  attach_function :options_set_info_log, :leveldb_options_set_info_log, [Options, Logger], :void

  # (Not documented)
  #
  # @method options_set_max_open_files(options, int)
  # @param [Options] options
  # @param [Integer] int
  # @return [nil]
  # @scope class
  #
  attach_function :options_set_max_open_files, :leveldb_options_set_max_open_files, [Options, :int], :void

  # (Not documented)
  #
  # @method options_set_block_size(options, u_long)
  # @param [Options] options
  # @param [Integer] u_long
  # @return [nil]
  # @scope class
  #
  attach_function :options_set_block_size, :leveldb_options_set_block_size, [Options, :ulong], :void

  # (Not documented)
  #
  # @method options_set_compression(options, int)
  # @param [Options] options
  # @param [Integer] int
  # @return [nil]
  # @scope class
  #
  attach_function :options_set_compression, :leveldb_options_set_compression, [Options, :int], :void

  # Comparator
  #
  # @method comparator_destroy(comparator)
  # @param [Comparator] comparator
  # @return [nil]
  # @scope class
  #
  attach_function :comparator_destroy, :leveldb_comparator_destroy, [Comparator], :void

  # Filter policy
  #
  # @method filterpolicy_destroy(filterpolicy)
  # @param [Filterpolicy] filterpolicy
  # @return [nil]
  # @scope class
  #
  attach_function :filterpolicy_destroy, :leveldb_filterpolicy_destroy, [Filterpolicy], :void

  # Read options
  #
  # @method readoptions_create()
  # @return [Readoptions]
  # @scope class
  #
  attach_function :readoptions_create, :leveldb_readoptions_create, [], Readoptions

  # (Not documented)
  #
  # @method readoptions_set_verify_checksums(readoptions, u_char)
  # @param [Readoptions] readoptions
  # @param [Integer] u_char
  # @return [nil]
  # @scope class
  #
  attach_function :readoptions_set_verify_checksums, :leveldb_readoptions_set_verify_checksums, [Readoptions, :uchar], :void

  # (Not documented)
  #
  # @method readoptions_set_snapshot(readoptions, snapshot)
  # @param [Readoptions] readoptions
  # @param [Snapshot] snapshot
  # @return [nil]
  # @scope class
  #
  attach_function :readoptions_set_snapshot, :leveldb_readoptions_set_snapshot, [Readoptions, Snapshot], :void

  # Write options
  #
  # @method writeoptions_destroy(writeoptions)
  # @param [Writeoptions] writeoptions
  # @return [nil]
  # @scope class
  #
  attach_function :writeoptions_destroy, :leveldb_writeoptions_destroy, [Writeoptions], :void

  # Cache
  #
  # @method cache_create_lru(capacity)
  # @param [Integer] capacity
  # @return [Cache]
  # @scope class
  #
  attach_function :cache_create_lru, :leveldb_cache_create_lru, [:ulong], Cache

  # Env
  #
  # @method create_default_env()
  # @return [Env]
  # @scope class
  #
  attach_function :create_default_env, :leveldb_create_default_env, [], Env

  # Calls free(ptr).
  #    REQUIRES: ptr was malloc()-ed and returned by one of the routines
  #    in this file.  Note that in certain cases (typically on Windows), you
  #    may need to call this routine instead of free(ptr) to dispose of
  #    malloc()-ed memory returned by this library.
  #
  # @method free(ptr)
  # @param [FFI::Pointer(*Void)] ptr
  # @return [nil]
  # @scope class
  #
  attach_function :free, :leveldb_free, [:pointer], :void

  # Return the minor version number for this release.
  #
  # @method minor_version()
  # @return [Integer]
  # @scope class
  #
  attach_function :minor_version, :leveldb_minor_version, [], :int

  # (Not documented)
  #
  # @method close(db)
  # @param [T] db
  # @return [nil]
  # @scope class
  #
  attach_function :close, :leveldb_close, [T], :void

  # Returns NULL if not found.  A malloc()ed array otherwise.
  #    Stores the length of the array in *vallen.
  #
  # @method get(db, options, key, keylen, vallen, errptr)
  # @param [T] db
  # @param [Readoptions] options
  # @param [String] key
  # @param [Integer] keylen
  # @param [FFI::Pointer(*Size)] vallen
  # @param [FFI::Pointer(**CharS)] errptr
  # @return [String]
  # @scope class
  #
  attach_function :get, :leveldb_get, [T, Readoptions, :string, :ulong, :pointer, :pointer], :string

  # Returns NULL if property name is unknown.
  #    Else returns a pointer to a malloc()-ed null-terminated value.
  #
  # @method property_value(db, propname)
  # @param [T] db
  # @param [String] propname
  # @return [String]
  # @scope class
  #
  attach_function :property_value, :leveldb_property_value, [T, :string], :string

  # Management operations
  #
  # @method repair_db(options, name, errptr)
  # @param [Options] options
  # @param [String] name
  # @param [FFI::Pointer(**CharS)] errptr
  # @return [nil]
  # @scope class
  #
  attach_function :repair_db, :leveldb_repair_db, [Options, :string, :pointer], :void

  # Iterator
  #
  # @method iter_seek_to_last(iterator)
  # @param [Iterator] iterator
  # @return [nil]
  # @scope class
  #
  attach_function :iter_seek_to_last, :leveldb_iter_seek_to_last, [Iterator], :void

  # (Not documented)
  #
  # @method iter_key(iterator, klen)
  # @param [Iterator] iterator
  # @param [FFI::Pointer(*Size)] klen
  # @return [String]
  # @scope class
  #
  attach_function :iter_key, :leveldb_iter_key, [Iterator, :pointer], :string

  # Write batch
  #
  # @method writebatch_destroy(writebatch)
  # @param [Writebatch] writebatch
  # @return [nil]
  # @scope class
  #
  attach_function :writebatch_destroy, :leveldb_writebatch_destroy, [Writebatch], :void

  # (Not documented)
  #
  # @method writebatch_iterate(writebatch, state, put, deleted)
  # @param [Writebatch] writebatch
  # @param [FFI::Pointer(*Void)] state
  # @param [FFI::Pointer(*)] put
  # @param [FFI::Pointer(*)] deleted
  # @return [nil]
  # @scope class
  #
  attach_function :writebatch_iterate, :leveldb_writebatch_iterate, [Writebatch, :pointer, :pointer, :pointer], :void

  # Options
  #
  # @method options_set_filter_policy(options, filterpolicy)
  # @param [Options] options
  # @param [Filterpolicy] filterpolicy
  # @return [nil]
  # @scope class
  #
  attach_function :options_set_filter_policy, :leveldb_options_set_filter_policy, [Options, Filterpolicy], :void

  # (Not documented)
  #
  # @method options_set_env(options, env)
  # @param [Options] options
  # @param [Env] env
  # @return [nil]
  # @scope class
  #
  attach_function :options_set_env, :leveldb_options_set_env, [Options, Env], :void

  # (Not documented)
  #
  # @method options_set_cache(options, cache)
  # @param [Options] options
  # @param [Cache] cache
  # @return [nil]
  # @scope class
  #
  attach_function :options_set_cache, :leveldb_options_set_cache, [Options, Cache], :void

  # Comparator
  #
  # @method comparator_create(state, destructor, compare, name)
  # @param [FFI::Pointer(*Void)] state
  # @param [FFI::Pointer(*)] destructor
  # @param [FFI::Pointer(*)] compare
  # @param [FFI::Pointer(*)] name
  # @return [Comparator]
  # @scope class
  #
  attach_function :comparator_create, :leveldb_comparator_create, [:pointer, :pointer, :pointer, :pointer], Comparator

  # Filter policy
  #
  # @method filterpolicy_create_bloom(bits_per_key)
  # @param [Integer] bits_per_key
  # @return [Filterpolicy]
  # @scope class
  #
  attach_function :filterpolicy_create_bloom, :leveldb_filterpolicy_create_bloom, [:int], Filterpolicy

  # Read options
  #
  # @method readoptions_set_fill_cache(readoptions, u_char)
  # @param [Readoptions] readoptions
  # @param [Integer] u_char
  # @return [nil]
  # @scope class
  #
  attach_function :readoptions_set_fill_cache, :leveldb_readoptions_set_fill_cache, [Readoptions, :uchar], :void

  # Write options
  #
  # @method writeoptions_set_sync(writeoptions, u_char)
  # @param [Writeoptions] writeoptions
  # @param [Integer] u_char
  # @return [nil]
  # @scope class
  #
  attach_function :writeoptions_set_sync, :leveldb_writeoptions_set_sync, [Writeoptions, :uchar], :void

  # Env
  #
  # @method env_destroy(env)
  # @param [Env] env
  # @return [nil]
  # @scope class
  #
  attach_function :env_destroy, :leveldb_env_destroy, [Env], :void

  # (Not documented)
  #
  # @method delete(db, options, key, keylen, errptr)
  # @param [T] db
  # @param [Writeoptions] options
  # @param [String] key
  # @param [Integer] keylen
  # @param [FFI::Pointer(**CharS)] errptr
  # @return [nil]
  # @scope class
  #
  attach_function :delete, :leveldb_delete, [T, Writeoptions, :string, :ulong, :pointer], :void

  # Returns NULL if property name is unknown.
  #    Else returns a pointer to a malloc()-ed null-terminated value.
  #
  # @method compact_range(db, start_key, start_key_len, limit_key, limit_key_len)
  # @param [T] db
  # @param [String] start_key
  # @param [Integer] start_key_len
  # @param [String] limit_key
  # @param [Integer] limit_key_len
  # @return [nil]
  # @scope class
  #
  attach_function :compact_range, :leveldb_compact_range, [T, :string, :ulong, :string, :ulong], :void

  # Iterator
  #
  # @method iter_next(iterator)
  # @param [Iterator] iterator
  # @return [nil]
  # @scope class
  #
  attach_function :iter_next, :leveldb_iter_next, [Iterator], :void

  # Write batch
  #
  # @method writebatch_put(writebatch, key, klen, val, vlen)
  # @param [Writebatch] writebatch
  # @param [String] key
  # @param [Integer] klen
  # @param [String] val
  # @param [Integer] vlen
  # @return [nil]
  # @scope class
  #
  attach_function :writebatch_put, :leveldb_writebatch_put, [Writebatch, :string, :ulong, :string, :ulong], :void

  # Options
  #
  # @method options_set_error_if_exists(options, u_char)
  # @param [Options] options
  # @param [Integer] u_char
  # @return [nil]
  # @scope class
  #
  attach_function :options_set_error_if_exists, :leveldb_options_set_error_if_exists, [Options, :uchar], :void

  # (Not documented)
  #
  # @method options_set_block_restart_interval(options, int)
  # @param [Options] options
  # @param [Integer] int
  # @return [nil]
  # @scope class
  #
  attach_function :options_set_block_restart_interval, :leveldb_options_set_block_restart_interval, [Options, :int], :void

  # Read options
  #
  # @method readoptions_destroy(readoptions)
  # @param [Readoptions] readoptions
  # @return [nil]
  # @scope class
  #
  attach_function :readoptions_destroy, :leveldb_readoptions_destroy, [Readoptions], :void

  # Cache
  #
  # @method cache_destroy(cache)
  # @param [Cache] cache
  # @return [nil]
  # @scope class
  #
  attach_function :cache_destroy, :leveldb_cache_destroy, [Cache], :void

  # (Not documented)
  #
  # @method create_snapshot(db)
  # @param [T] db
  # @return [Snapshot]
  # @scope class
  #
  attach_function :create_snapshot, :leveldb_create_snapshot, [T], Snapshot

  # Iterator
  #
  # @method iter_get_error(iterator, errptr)
  # @param [Iterator] iterator
  # @param [FFI::Pointer(**CharS)] errptr
  # @return [nil]
  # @scope class
  #
  attach_function :iter_get_error, :leveldb_iter_get_error, [Iterator, :pointer], :void

  # Options
  #
  # @method options_set_write_buffer_size(options, u_long)
  # @param [Options] options
  # @param [Integer] u_long
  # @return [nil]
  # @scope class
  #
  attach_function :options_set_write_buffer_size, :leveldb_options_set_write_buffer_size, [Options, :ulong], :void

  # Write options
  #
  # @method writeoptions_create()
  # @return [Writeoptions]
  # @scope class
  #
  attach_function :writeoptions_create, :leveldb_writeoptions_create, [], Writeoptions

  # (Not documented)
  #
  # @method iter_valid(iterator)
  # @param [Iterator] iterator
  # @return [Integer]
  # @scope class
  #
  attach_function :iter_valid, :leveldb_iter_valid, [Iterator], :uchar

  # Filter policy
  #
  # @method filterpolicy_create(state, destructor, create_filter, key_may_match, name)
  # @param [FFI::Pointer(*Void)] state
  # @param [FFI::Pointer(*)] destructor
  # @param [FFI::Pointer(*)] create_filter
  # @param [FFI::Pointer(*)] key_may_match
  # @param [FFI::Pointer(*)] name
  # @return [Filterpolicy]
  # @scope class
  #
  attach_function :filterpolicy_create, :leveldb_filterpolicy_create, [:pointer, :pointer, :pointer, :pointer, :pointer], Filterpolicy

  # (Not documented)
  #
  # @method options_destroy(options)
  # @param [Options] options
  # @return [nil]
  # @scope class
  #
  attach_function :options_destroy, :leveldb_options_destroy, [Options], :void

  # Return the major version number for this release.
  #
  # @method major_version()
  # @return [Integer]
  # @scope class
  #
  attach_function :major_version, :leveldb_major_version, [], :int

end
