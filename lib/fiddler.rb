require 'fiddle'
require 'fiddle/import'
require 'rbconfig'

module Fiddler
  include Fiddle
  include Fiddle::CParser
  include Fiddle::Importer
  extend Fiddle::Importer
  extend self

  LIBSUFFIX =
    case RbConfig::CONFIG['host_os'].downcase
    when /windows|cgywin/ then 'dll'
    when /darwin/         then 'dylib'
    else 'so'
    end

  LIBPATHS =
    [ '/usr/local/lib',
      '/opt/local/lib',
      '/usr/lib64',
      File.expand_path("../../ext/leveldb", __FILE__)]

  def dlload(*libs)
    libs.map! do |lib|
      LIBPATHS.map { |l| File.join(l, "#{lib}.#{LIBSUFFIX}") }.
      detect { |l| File.exist?(l) }
    end
    super(*libs)
  end

  # Alias CTypes
  ::Fiddle.constants.each do |c|
    next unless c.to_s =~ /^TYPE_(.+)$/
    const_set $1, const_get(c)
  end

  ULONG  = -LONG
  LLONG  =  LONG_LONG
  ULLONG = -LONG_LONG
  UCHAR  = -CHAR
  USHORT = -SHORT
  UINT   = -INT

  def cdef(name, ret_type, args_types={}, options={})
    address     = handler["#{@_prefix}#{name}"] || handler[name.to_s]
    options     = {name: name}.merge(options)
    call_type   = options.delete(:call_type) || Function::DEFAULT
    params      = args_types.keys.join(', ')
    values      = args_types.values
    cdefs[name] = Function.new(address, values, ret_type, call_type, options)

    module_eval <<-RB, __FILE__, __LINE__ + 1
    def #{name}(#{params})
      cdefs[#{name.inspect}].call(#{params})
    end
    module_function #{name.inspect}
    RB
  end

  def cdefs
    @_cdefs ||= {}
  end

  def [](val)
    cdefs[val]
  end

  def prefix(value)
    @_prefix = value
  end

  def self.included(base)
    base.extend self
  end
end
