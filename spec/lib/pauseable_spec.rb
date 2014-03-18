require 'spec_helper'

class Dummy
  extend Hiatus::Pauseable
end

describe Hiatus::Pauseable do
  before do
    @storage = Redis.new
    Hiatus.configure(@storage)
  end

  describe 'pause' do
    context 'without a number of seconds specified' do
      before { Dummy.pause }

      it 'the computed key is not nil' do
        expect(@storage.get('hiatus:dummy')).not_to be_nil
      end

      it 'has a ttl of 30 minutes (1800 seconds)' do
        time_remaining = @storage.ttl('hiatus:dummy')
        expect(time_remaining).to be_within(5).of(1800)
      end
    end

    context 'with 246 seconds' do
      before { Dummy.pause(246) }

      it 'the computed key is not nil' do
        expect(@storage.get('hiatus:dummy')).not_to be_nil
      end

      it 'has a ttl of 246 seconds' do
        time_remaining = @storage.ttl('hiatus:dummy')
        expect(time_remaining).to be_within(5).of(246)
      end
    end
  end

  describe 'paused?' do
    context 'when it has been paused' do
      before { Dummy.pause }

      it 'is true' do
        expect(Dummy.paused?).to be_true
      end
    end

    context 'when it has not been paused' do
      it 'is false' do
        expect(Dummy.paused?).to be_false
      end
    end
  end
end
