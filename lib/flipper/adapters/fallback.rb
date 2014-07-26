require 'flipper'
require 'flipper/adapters/memory'
require 'delegate'

module Flipper
  module Adapters
    class Fallback < SimpleDelegator
      VERSION = '0.0.2'
      def initialize(primary_adapter, fallback_adapter = Flipper::Adapters::Memory.new)
        super(primary_adapter)
        @primary_adapter = primary_adapter
        @fallback_adapter = fallback_adapter

        @delegate_sd_obj = primary_adapter
      end

      def method_missing(m, *args, &block)
        super
      rescue => e
        STDERR.puts("[Flipper::Adapters::Fallback] Primary adapter(#{@primary_adapter.inspect}) Failure! #{e}")
        STDERR.puts("[Flipper::Adapters::Fallback] Falling back to #{@fallback_adapter.inspect})")
        @fallback_adapter.__send__(m, *args, &block)
      end
    end
  end
end
