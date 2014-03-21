require 'hiatus'

module Hiatus
  module Pausable
    def pause(seconds = 1800)
      Hiatus.pause(hiatus_key, seconds)
    end

    def paused?
      !!Hiatus.paused?(hiatus_key)
    end

    private

    def hiatus_key
      self.to_s.downcase
    end
  end
end
