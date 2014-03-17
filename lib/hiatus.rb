require 'hiatus/version'

module Hiatus
  def self.configure(configured_key_value_store)
    @storage ||= configured_key_value_store
  end

  def self.pause(processes, seconds = 1800)
    Array(processes).all? { |process| update(process, seconds) }
  end

  def self.paused?(process)
    !!@storage.get(namespace(process))
  end

  private

  def self.namespace(process)
    [ 'hiatus', process.to_s ].join(':')
  end

  def self.update(name, time)
    @storage.setex(namespace(name), time, 'on hiatus')
  end

  module KillSwitch
    def pause(seconds = 1800)
      Hiatus.pause(key, seconds)
    end

    def paused?
      !!Hiatus.paused?(key)
    end

    private

    def key
      self.to_s.downcase
    end
  end
end
