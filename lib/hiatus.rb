require 'hiatus/version'
require 'pauseable'

module Hiatus
  NAMESPACE = 'hiatus:'
  private_constant :NAMESPACE

  def self.summary
    hiatus_all_keys.map do |key|
      {
        process: key.sub(NAMESPACE, ''),
        seconds_remaining: Redis.current.ttl(key),
        paused_at: Redis.current.get(key)
      }
    end
  end

  def self.pause(processes, seconds = 1800)
    Array(processes).all? { |process| hiatus_update(process, seconds) }
  end

  def self.paused?(process)
    !!Redis.current.get( namespace(process) )
  end

  private

  def self.namespace(process)
    NAMESPACE + process.to_s
  end

  def self.hiatus_update(process, time)
    Redis.current.setex(namespace(process), time, timestamp)
  end

  def self.hiatus_all_keys
    Redis.current.keys(NAMESPACE + '*')
  end

  def self.timestamp
    Redis.current.time.first
  end
end
