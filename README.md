# Hiatus

This gem will allow you to use Redis to pause and check for paused status of things.

## Installation

Add this line to your application's Gemfile:

    gem 'hiatus'

And then install with Bundler:

    bundle install

Or install it globally:

    gem install hiatus

## Usage

### Initialization / Dependency

You must have the thread-safe `Redis.current` set up

### Extending an existing model

```ruby
class YeOldeBlob
  extend Hiatus::Pauseable

  def self.process_everything
    return if paused?
    ...
  end
end

rake stop_blobs do
  YeOldeBlob.pause
end
```

### Pausing processes by name

```ruby
rake read_only_maintenance_mode do
  Hiatus.pause([:blobs, :jobs, :screaming_sobs], 2000)
end
```

```ruby
class BlobProcessor
  def process
    return if Hiatus.paused?(:blobs)
    ...
  end
end
```

## Contributing

1. Fork it ( http://github.com/shopkeep/hiatus/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
