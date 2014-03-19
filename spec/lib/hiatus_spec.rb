require 'spec_helper'

describe Hiatus do
  let(:redis) { Redis.new }
  let(:redis_time) { Time.at(1385107188) }

  before { Redis.current.stub(:time).and_return([redis_time.to_i, 000000]) }

  describe '.pause' do
    context 'with a single process and no time given' do
      before { Hiatus.pause(:arbitrary_migration) }

      it 'the computed key is not nil' do
        expect(redis.get('hiatus:arbitrary_migration')).not_to be_nil
      end

      it 'has a ttl of 30 minutes (1800 seconds)' do
        time_remaining = redis.ttl('hiatus:arbitrary_migration')
        expect(time_remaining).to be_within(5).of(1800)
      end

      it 'has a value with the current timestamp' do
        expect(redis.get('hiatus:arbitrary_migration')).to eql '1385107188'
      end
    end

    context 'with a single process and explicit 45 seconds' do
      before { Hiatus.pause(:arbitrary_migration, 45) }

      it 'the computed key is not nil' do
        expect(redis.get('hiatus:arbitrary_migration')).not_to be_nil
      end

      it 'has a ttl of 45 seconds' do
        time_remaining = redis.ttl('hiatus:arbitrary_migration')
        expect(time_remaining).to be_within(5).of(45)
      end
    end

    context 'with an array of processes and explicit 45 seconds' do
      before do
        Hiatus.pause([ :arbitrary_migration, :regular_processing_job, :transmission_worker ], 45)
      end

      it 'arbitrary_migration has a key set' do
        expect(redis.get('hiatus:arbitrary_migration')).not_to be_nil
      end

      it 'regular_processing_job has a key set' do
        expect(redis.get('hiatus:regular_processing_job')).not_to be_nil
      end

      it 'transmission_worker has a key set' do
        expect(redis.get('hiatus:transmission_worker')).not_to be_nil
      end

      it 'arbitrary_migration has a ttl of 45 seconds' do
        time_remaining = redis.ttl('hiatus:arbitrary_migration')
        expect(time_remaining).to be_within(5).of(45)
      end

      it 'regular_processing_job has a ttl of 45 seconds' do
        time_remaining = redis.ttl('hiatus:regular_processing_job')
        expect(time_remaining).to be_within(5).of(45)
      end

      it 'transmission_worker has a ttl of 45 seconds' do
        time_remaining = redis.ttl('hiatus:transmission_worker')
        expect(time_remaining).to be_within(5).of(45)
      end
    end
  end

  describe 'paused?' do
    context 'with a paused arbitrary_migration' do
      before { Hiatus.pause(:arbitrary_migration) }

      it 'is true' do
        expect(Hiatus.paused?(:arbitrary_migration)).to be_true
      end
    end

    context 'without anything paused' do
      it 'is false' do
        expect(Hiatus.paused?(:green_skittles)).to be_false
      end
    end
  end
end