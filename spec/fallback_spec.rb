require 'helper'
require 'flipper/adapters/redis'
require 'flipper/adapters/fallback'
require 'flipper/spec/shared_adapter_specs'

describe Flipper::Adapters::Fallback do
  context "when redis is available" do
    let(:client) {
      options = {}

      if ENV['BOXEN_REDIS_URL']
        options[:url] = ENV['BOXEN_REDIS_URL']
      end

      Redis.new(options)
    }

    subject { described_class.new(Flipper::Adapters::Redis.new(client)) }

    before do
      client.flushdb
    end

    it_should_behave_like 'a flipper adapter'
  end

  context "when redis is not available" do
    let(:client) {
      options = {}

      if ENV['BOXEN_REDIS_URL']
        options[:url] = "redis://doesnotexit:1"
      end

      Redis.new(options)
    }

    subject { described_class.new(Flipper::Adapters::Redis.new(client)) }

    it_should_behave_like 'a flipper adapter'
  end
end
