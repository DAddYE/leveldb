require 'fiddler'

module LevelDB
  module Native
    include Fiddler

    prefix 'leveldb_'
    dlload 'libleveldb'

    cdef :open, VOIDP, options: VOIDP, name: VOIDP, errptr: VOIDP
    cdef :put, VOID, db: VOIDP, options: VOIDP, key: VOIDP, keylen: ULONG, val: VOIDP, vallen: ULONG, errptr: VOIDP
    cdef :get, VOIDP, db: VOIDP, options: VOIDP, key: VOIDP, keylen: ULONG, vallen: VOIDP, errptr: VOIDP
    cdef :delete, VOID, db: VOIDP, options: VOIDP, key: VOIDP, keylen: ULONG, errptr: VOIDP
    cdef :destroy_db, VOID, options: VOIDP, name: VOIDP, errptr: VOIDP
    cdef :repair_db, VOID, options: VOIDP, name: VOIDP, errptr: VOIDP
    cdef :release_snapshot, VOID, db: VOIDP, snapshot: VOIDP
    cdef :create_snapshot, VOIDP, db: VOIDP
    cdef :approximate_sizes, VOID, db: VOIDP, num_ranges: INT, range_start_key: VOIDP, range_start_key_len: VOIDP, range_limit_key: VOIDP, range_limit_key_len: VOIDP, sizes: VOIDP
    cdef :close, VOID, db: VOIDP
    cdef :property_value, VOIDP, db: VOIDP, propname: VOIDP
    cdef :compact_range, VOID, db: VOIDP, start_key: VOIDP, start_key_len: ULONG, limit_key: VOIDP, limit_key_len: ULONG
    cdef :free, VOID, ptr: VOIDP

    cdef :create_iterator, VOIDP, db: VOIDP, options: VOIDP
    cdef :iter_destroy, VOID, iterator: VOIDP
    cdef :iter_seek_to_first, VOID, iterator: VOIDP
    cdef :iter_seek, VOID, iterator: VOIDP, k: VOIDP, klen: ULONG
    cdef :iter_prev, VOID, iterator: VOIDP
    cdef :iter_key, VOIDP, iterator: VOIDP, klen: VOIDP
    cdef :iter_value, VOIDP, iterator: VOIDP, vlen: VOIDP
    cdef :iter_get_error, VOID, iterator: VOIDP, errptr: VOIDP
    cdef :iter_valid, UCHAR, iterator: VOIDP
    cdef :iter_next, VOID, iterator: VOIDP
    cdef :iter_seek_to_last, VOID, iterator: VOIDP

    cdef :writebatch_create, VOIDP
    cdef :writebatch_clear, VOID, writebatch: VOIDP
    cdef :writebatch_put, VOID, writebatch: VOIDP, key: VOIDP, klen: ULONG, val: VOIDP, vlen: ULONG
    cdef :writebatch_delete, VOID, writebatch: VOIDP, key: VOIDP, klen: ULONG
    cdef :writebatch_destroy, VOID, writebatch: VOIDP
    cdef :writebatch_iterate, VOID, writebatch: VOIDP, state: VOIDP, put: VOIDP, deleted: VOIDP
    cdef :write, VOID, db: VOIDP, options: VOIDP, batch: VOIDP, errptr: VOIDP

    cdef :options_create, VOIDP
    cdef :options_set_comparator, VOID, options: VOIDP, comparator: VOIDP
    cdef :options_set_create_if_missing, VOID, options: VOIDP, u_char: UCHAR
    cdef :options_set_paranoid_checks, VOID, options: VOIDP, u_char: UCHAR
    cdef :options_set_info_log, VOID, options: VOIDP, logger: VOIDP
    cdef :options_set_max_open_files, VOID, options: VOIDP, int: INT
    cdef :options_set_block_size, VOID, options: VOIDP, u_long: ULONG
    cdef :options_set_compression, VOID, options: VOIDP, int: INT
    cdef :options_set_filter_policy, VOID, options: VOIDP, filterpolicy: VOIDP
    cdef :options_set_env, VOID, options: VOIDP, env: VOIDP
    cdef :options_set_cache, VOID, options: VOIDP, cache: VOIDP
    cdef :options_set_error_if_exists, VOID, options: VOIDP, u_char: UCHAR
    cdef :options_set_block_restart_interval, VOID, options: VOIDP, int: INT
    cdef :options_set_write_buffer_size, VOID, options: VOIDP, u_long: ULONG
    cdef :options_destroy, VOID, options: VOIDP

    cdef :readoptions_create, VOIDP
    cdef :readoptions_destroy, VOID, readoptions: VOIDP
    cdef :readoptions_set_verify_checksums, VOID, readoptions: VOIDP, u_char: UCHAR
    cdef :readoptions_set_snapshot, VOID, readoptions: VOIDP, snapshot: VOIDP
    cdef :readoptions_set_fill_cache, VOID, readoptions: VOIDP, u_char: UCHAR

    cdef :cache_create_lru, VOIDP, capacity: ULONG
    cdef :cache_destroy, VOID, cache: VOIDP

    cdef :create_default_env, VOIDP
    cdef :env_destroy, VOID, env: VOIDP

    cdef :comparator_create, VOIDP, state: VOIDP, destructor: VOIDP, compare: VOIDP, name: VOIDP
    cdef :comparator_destroy, VOID, comparator: VOIDP

    cdef :writeoptions_destroy, VOID, writeoptions: VOIDP
    cdef :writeoptions_set_sync, VOID, writeoptions: VOIDP, u_char: UCHAR
    cdef :writeoptions_create, VOIDP

    cdef :filterpolicy_create_bloom, VOIDP, bits_per_key: INT
    cdef :filterpolicy_create, VOIDP, state: VOIDP, destructor: VOIDP, create_filter: VOIDP, key_may_match: VOIDP, name: VOIDP
    cdef :filterpolicy_destroy, VOID, filterpolicy: VOIDP

    cdef :minor_version, INT
    cdef :major_version, INT
  end
end
