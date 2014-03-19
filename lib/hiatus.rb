require 'hiatus/version'
require 'pauseable'

module Hiatus
  def self.pause(processes, seconds = 1800)
    Array(processes).all? { |process| hiatus_update(process, seconds) }
  end

  def self.paused?(process)
    !!Redis.current.get(hiatus_namespace(process))
  end

  private

  def self.hiatus_namespace(process)
    [ 'hiatus', process.to_s ].join(':')
  end

  def self.hiatus_update(name, time)
    Redis.current.setex(hiatus_namespace(name), time, 'on hiatus')
  end
end
