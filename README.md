# Hiatus

This gem will allow you to use Redis to pause and check for paused status of things

## Installation

Add this line to your application's Gemfile:

    gem 'hiatus'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hiatus

## Usage

In an initializer, do this:

```ruby
Hiatus.configure(Redis.new)
```

Uses:

1. Extend an existing model:

```ruby
class YeOldeBlob
  extend Hiatus::KillSwitch

  def self.process_everything
    return if paused?
    ...
  end
end

rake stop_blobs do
  YeOldeBlob.pause
end

```

2. Pause one or more processes by name

```ruby
rake read_only_maintenance_mode do
  Hiatus.pause([:blobs, :jobs, :screaming_sobs], 2000)
end

Hiatus.paused?(:blobs) => true
```

## Contributing

1. Fork it ( http://github.com/<my-github-username>/hiatus/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
