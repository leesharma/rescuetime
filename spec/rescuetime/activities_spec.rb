require 'spec_helper'

describe Rescuetime::Activities do
  before do
    @client = Rescuetime::Client.new(api_key: 'AK')
  end

  describe '#productivity_levels' do
    it 'returns map of numeric productivity levels to meaning' do
      expect(@client.productivity_levels).to be_an_instance_of(Hash)
      expect(@client.productivity_levels.keys).to eq([-2,-1,0,1,2])
    end
  end

  describe '#activities' do
    it 'returns list of activities' do
      VCR.use_cassette('/data?key=AK',
                       match_requests_on: [:host, :path], record: :none) do
        expect(@client.activities).to be_instance_of(Array)
        expect(@client.activities[0]).to be_instance_of(Hash)
      end
    end

    describe 'perspective' do
      describe "'rank'" do
        it 'is grouped and sorted by rank' do
          VCR.use_cassette('/data?key=AK&perspective=rank',
                           match_requests_on: [:host, :path], record: :none) do
            activity_keys = @client.activities(perspective: 'rank')[0].keys
            expect(activity_keys).to include(:rank)
          end
        end
      end
      describe "'interval'" do
        it 'is returned chronologically' do
          VCR.use_cassette('/data?key=AK&perspective=interval',
                           match_requests_on: [:host, :path], record: :none) do
            activity_keys = @client.activities(perspective: 'interval')[0].keys
            expect(activity_keys).to include(:date)
          end
        end
      end
      describe "'member'" do
        it 'is grouped and sorted by member' do
          VCR.use_cassette('/data?key=AK&perspective=member',
                           match_requests_on: [:host, :path], record: :none) do
            activity_keys = @client.activities(perspective: 'member')[0].keys
            expect(activity_keys).to include(:person)
          end
        end
      end
    end
    describe 'restrict_kind:' do
      describe "'overview'" do
        it 'restricts activity detail to overview' do
          VCR.use_cassette('/data?key=AK&restrict_kind=overview',
                           match_requests_on: [:host, :path], record: :none) do
            activities = @client.activities restrict_kind: 'overview'
            activity_keys = activities[0].keys
            expect(activity_keys).to include(:category)
            expect(activity_keys).not_to include(:activity)
            expect(activity_keys).not_to include(:productivity)
          end
        end
      end

      describe "'category'" do
        it 'restricts activity detail to category' do
          VCR.use_cassette('/data?key=AK&restrict_kind=category',
                           match_requests_on: [:host, :path], record: :none) do
            activities = @client.activities restrict_kind: 'category'
            activity_keys = activities[0].keys
            expect(activity_keys).to include(:category)
            expect(activity_keys).not_to include(:activity)
            expect(activity_keys).not_to include(:productivity)
          end
        end
      end

      describe "'activity'" do
        it 'restricts activity detail to activity' do
          VCR.use_cassette('/data?key=AK&restrict_kind=activity',
                           match_requests_on: [:host, :path], record: :none) do
            activities = @client.activities restrict_kind: 'activity'
            activity_keys = activities[0].keys
            expect(activity_keys).to include(:activity)
          end
        end
      end

      describe "'productivity'" do
        it 'returns productivity report' do
          VCR.use_cassette('/data?key=AK&restrict_kind=productivity',
                           match_requests_on: [:host, :path], record: :none) do
            activities = @client.activities restrict_kind: 'productivity'
            activity_keys = activities[0].keys
            expect(activity_keys).to include(:productivity)
            expect(activity_keys).not_to include(:activity)
            expect(activity_keys).not_to include(:category)
          end
        end
      end

      describe "'efficiency'" do
        it 'returns efficiency report (only valid with by: \'time\')' do
          # TODO: Need to implement :by before this will work
        end
      end
    end
  end
end