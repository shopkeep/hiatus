require 'hiatus'

module Hiatus
  module Pauseable
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
