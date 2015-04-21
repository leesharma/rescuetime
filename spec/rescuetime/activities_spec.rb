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

    describe 'date:' do
      describe "'YYYY-MM-DD'" do
        it 'sets the date for the report data' do
          VCR.use_cassette('/data?key=AK&perspective=interval&restrict_begin=2015-04-20&restrict_end=2015-04-20',
                           match_requests_on: [:host, :path], record: :none) do
            activities = @client.activities by: 'time', date: '2015-04-20'
            valid = /2015-04-20/

            invalid_date_count = count_invalid_dates(activities, valid)
            expect(invalid_date_count).to eq(0)
          end
        end
      end
    end

    describe 'from:' do
      describe "and to: 'YYYY-MM-DD'" do
        it 'sets the start and end date for the report data' do
          VCR.use_cassette('/data?key=AK&perspective=interval&restrict_begin=2015-04-15&restrict_end=2015-04-17',
                           match_requests_on: [:host, :path], record: :none) do
            activities = @client.activities by: 'time', from: '2015-04-15', to: '2015-04-17'
            valid = /(2015-04-15|2015-04-16|2015-04-17)/

            invalid_date_count = count_invalid_dates(activities, valid)
            expect(invalid_date_count).to eq(0)
          end
        end
      end
      describe "'YYYY-MM-DD' (:to not set)" do
        it 'sets the start date for the report data with the end date being today' do
          VCR.use_cassette('/data?key=AK&perspective=interval&restrict_begin=2015-04-19&restrict_end=2015-04-21',
                           match_requests_on: [:host, :path], record: :none) do
            # Note: this cassette was recorded on 2015-04-21. If you wish to
            #   record it again, be sure to adjust 'valid', options[:from], and
            #   the cassette title to something reasonable.
            activities = @client.activities by: 'time', from: '2015-04-19'
            valid = /(2015-04-19|2015-04-20|2015-04-21)/

            invalid_date_count = count_invalid_dates(activities, valid)
            expect(invalid_date_count).to eq(0)
          end
        end
      end
    end

    describe 'format:' do
      describe "'csv'" do
        it 'returns in csv format' do
          VCR.use_cassette('/data?key=AK',
                           match_requests_on: [:host, :path], record: :none) do
            csv = @client.activities format: 'csv'
            expect(csv).to be_an_instance_of(CSV)
          end
        end
      end
    end

    describe 'by:' do
      describe "'rank'" do
        it 'is grouped and sorted by rank' do
          VCR.use_cassette('/data?key=AK&perspective=rank',
                           match_requests_on: [:host, :path], record: :none) do
            activity_keys = collect_keys @client.activities(by: 'rank')
            expect(activity_keys).to include(:rank)
          end
        end
      end
      describe "'time'" do
        it 'is returned chronologically' do
          VCR.use_cassette('/data?key=AK&perspective=interval',
                           match_requests_on: [:host, :path], record: :none) do
            activity_keys = collect_keys @client.activities(by: 'time')
            expect(activity_keys).to include(:date)
          end
        end
      end
      describe "'member'" do
        it 'is grouped and sorted by member' do
          VCR.use_cassette('/data?key=AK&perspective=member',
                           match_requests_on: [:host, :path], record: :none) do
            activity_keys = collect_keys @client.activities(by: 'member')
            expect(activity_keys).to include(:person)
          end
        end
      end
    end
    describe 'detail:' do
      describe "'overview'" do
        it 'restricts activity detail to overview' do
          VCR.use_cassette('/data?key=AK&restrict_kind=overview',
                           match_requests_on: [:host, :path], record: :none) do
            activity_keys = collect_keys @client.activities(detail: 'overview')

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
            activity_keys = collect_keys @client.activities(detail: 'category')

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
            activity_keys = collect_keys @client.activities(detail: 'activity')

            expect(activity_keys).to include(:activity)
          end
        end
      end

      describe "'productivity'" do
        it 'returns productivity report' do
          VCR.use_cassette('/data?key=AK&restrict_kind=productivity',
                           match_requests_on: [:host, :path], record: :none) do
            activity_keys = collect_keys @client.activities(detail: 'productivity')

            expect(activity_keys).to include(:productivity)
            expect(activity_keys).not_to include(:activity)
            expect(activity_keys).not_to include(:category)
          end
        end
      end

      describe "'efficiency'" do
        it 'returns efficiency report (only valid with by: \'time\')' do
          VCR.use_cassette('/data?key=AK&restrict_kind=efficiency&perspective=interval',
                           match_requests_on: [:host, :path], record: :none) do
            activity_keys = collect_keys @client.activities(detail: 'efficiency')

            expect(activity_keys).to include(:efficiency)
          end
        end
      end
    end
  end
end