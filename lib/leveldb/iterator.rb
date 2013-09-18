module LevelDB
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

    def inspect
      "#<LevelDB::Iterator:#{'0x%x' % object_id}>"
    end
    alias to_s inspect

    private
    def current
      return unless valid?


      cval = C.iter_key(@_iterator, @_read_len)
      len  = @_read_len.to_s.unpack('C')[0]

      key = len ? cval.to_s(len) : nil

      cval = C.iter_value(@_iterator, @_read_len)
      len = @_read_len.to_s.unpack('C')[0]

      val = len ? cval.to_s(len) : nil

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
