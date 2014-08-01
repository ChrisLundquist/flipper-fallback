# Flipper::Fallback

This gem lets you utilize multiple flipper adapters by providing a fall back pattern.
If the primary adapter fails by throwing an exception, the secondary adapter will be called.
By default, the fall back adapter is the in memory adapter which should not fail.
However, by default, the memory adapter is empty and ***everything will fail closed***

####What? Why do I care?
Maybe you're using an a flipper adapter like [flipper-redis](https://github.com/jnunemaker/flipper-redis).
If redis becomes unreachable, your site will 500. Flipper-fallback lets you handle that case.
Graceful degredation of service is often desirable.

## Installation

Add this line to your application's Gemfile:

    gem 'flipper-fallback'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install flipper-fallback

## Usage

Basic usage might look like this
```ruby
require 'flipper/adapters/redis'
require 'flipper/adapters/fallback'

flipper_adapter ||= Flipper::Adapters::Fallback.new(Flipper::Adapters::Redis.new(App.redis))
@flipper ||= Flipper.new(flipper_adapter)
```

If you wanted to set how things will fail, you should be able to do something like this.
```ruby
# Untested
# Please give me a better example of how one might do this
memory = Flipper::Adapters::Memory.new()
template = Flipper.new(memory)
template[:search].enable
template[:experimental].disable

# Template has modified our "memory" adapter to how we want
adapter = Flipper::Adapters::Fallback.new(Flipper::Adapters::Redis.new(App.redis), options = {}, memory)
```

Advanced usage might look like this
```ruby
error_handler = lambda do |error, primary_adapter, fallback_adapter|
  # Keep stats on how many and what kind of error we are seeing
  # There is probably a better way to do this
  statsd.increment("flipper.#{primary_adapter.name}.errors.#{error.to_s.gsub('.','_')}")
end

# Throw a timeout exception if we take more than 2 seconds.
# Timeout wraps both the primary and fallback adapters.
# If the primary adapter takes longer than 2 seconds, we won't even try the fallback
timeout_in_seconds = 2

flipper_adapter ||= Flipper::Adapters::Fallback.new(Flipper::Adapters::Redis.new(App.redis), :on_error => error_handler, :timeout => timeout_in_seconds)
@flipper ||= Flipper.new(flipper_adapter)
```

Some "creative" usage might look like this
```ruby
# Untested
# Make a list of adapters to try
head = Flipper::Adapters::Fallback.new(Flipper::Adapters::Memcache.new(Rails.cache))
head = Flipper::Adapters::Fallback.new(Flipper::Adapters::Redis.new(App.redis), { :timeout => 1 }, head)
head = Flipper::Adapters::Fallback.new(Flipper::Adapters::ElasticSearch.new(App.search), { :timeout => 1 }, head)

# This would try ES -> Redis -> Memcache -> Memory.
@flipper ||= Flipper.new(head)
```

## Contributing

1. Fork it ( https://github.com/[my-github-username]/flipper-fallback/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
