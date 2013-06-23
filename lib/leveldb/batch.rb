module LevelDB

  class Batch
    class Error < StandardError; end

    def initialize(db, write_opts)
      @_db = db
      @_write_opts = write_opts
      @_err = C::Pointer.malloc(C::SIZEOF_VOIDP)
      @_err.free = C[:free]
      @_batch = C.writebatch_create
    end

    def []=(key, val)
      key, val = key.to_s, val.to_s
      C.writebatch_put(@_batch, key, key.size, val, val.size)

      val
    end
    alias put []=

    def delete(key)
      key = key.to_s
      C.writebatch_delete(@_batch, key, key.size)

      key
    end

    # def clear
    #   C.writebatch_clear(@_batch)

    #   true
    # end
    # alias clear! clear

    def write!
      C.write(@_db, @_write_opts, @_batch, @_err)

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
end
