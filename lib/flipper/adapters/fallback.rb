require 'flipper'
require 'flipper/adapters/memory'
require 'delegate'
require 'timeout'

module Flipper
  module Adapters
    class Fallback < SimpleDelegator
      VERSION = '0.1.0'

      def initialize(primary_adapter, options = {}, fallback_adapter = Flipper::Adapters::Memory.new)
        super(primary_adapter)
        @primary_adapter = primary_adapter
        @fallback_adapter = fallback_adapter

        @delegate_sd_obj = primary_adapter

        @on_error = options[:on_error] || lambda do |error, primary_adapter, fallback_adapter|
          STDERR.puts("[Flipper::Adapters::Fallback] Primary adapter(#{primary_adapter.inspect}) Failure! #{error}")
          STDERR.puts("[Flipper::Adapters::Fallback] Falling back to #{fallback_adapter.inspect})")
        end

        @timeout = options[:timeout]
      end

      def method_missing(m, *args, &block)
        Timeout::timeout(@timeout) do
          begin
            super
          rescue => error
            @on_error.call(error, @primary_adapter, @fallback_adapter)
            @fallback_adapter.__send__(m, *args, &block)
          end
        end
      end
    end
  end
end
