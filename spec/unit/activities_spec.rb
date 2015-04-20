require 'spec_helper'

describe Rescuetime::Activities do
  before do
    @client = Rescuetime::Client.new(api_key: 'AK')
  end

  describe '#activities' do
    it 'exists' do
      expect(@client).to respond_to(:activities)
    end
    it 'returns list of activities' do
      VCR.use_cassette('default activities list',
                       match_requests_on: [:host, :path], record: :none) do
        expect(@client.activities).to be_instance_of(Array)
        expect(@client.activities[0]).to be_instance_of(Hash)
      end
    end
    describe 'restrict_kind:' do
      describe "'overview'" do
        it 'restricts activity detail to overview' do
          VCR.use_cassette('api_client.activities restrict_kind: overview',
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
          VCR.use_cassette('api_client.activities restrict_kind: category',
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
          VCR.use_cassette('api_client.activities restrict_kind: activity',
                           match_requests_on: [:host, :path], record: :none) do
            activities = @client.activities restrict_kind: 'activity'
            activity_keys = activities[0].keys
            expect(activity_keys).to include(:activity)
          end
        end
      end

      describe "'productivity'" do
        it 'returns productivity report' do
          VCR.use_cassette('api_client.activities restrict_kind: productivity',
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