require 'hiatus/version'
require 'kill_switch'

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
end
