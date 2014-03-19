require 'hiatus/version'
require 'pauseable'

module Hiatus
  def self.configure(configured_key_value_store)
    @storage ||= configured_key_value_store
  end

  def self.pause(processes, seconds = 1800)
    Array(processes).all? { |process| hiatus_update(process, seconds) }
  end

  def self.paused?(process)
    !!@storage.get(hiatus_namespace(process))
  end

  private

  def self.hiatus_namespace(process)
    [ 'hiatus', process.to_s ].join(':')
  end

  def self.hiatus_update(name, time)
    @storage.setex(hiatus_namespace(name), time, 'on hiatus')
  end
end
