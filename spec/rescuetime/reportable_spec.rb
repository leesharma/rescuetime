require 'spec_helper'

describe Rescuetime::Reportable, vcr: true do
  let(:client) { Rescuetime::Client.new(api_key: Secret::API_KEY) }

  describe '#overview' do
    subject { client.overview.fetch }
    it 'returns overview report' do
      expect(collect_keys subject).to include(:category)
    end
  end
  describe '#categories' do
    subject { client.categories.fetch }
    it 'returns report by category' do
      expect(collect_keys subject).to include(:category)
    end
  end
  describe '#activities' do
    subject { client.activities.fetch }
    it 'returns report by activity' do
      expect(collect_keys subject).to include(:activity, :category,
                                              :productivity)
    end
  end
  describe '#productivity' do
    subject { client.productivity.fetch }
    it 'returns productivity report' do
      expect(collect_keys subject).to include(:productivity)
    end
  end
  describe '#efficiency' do
    subject { client.efficiency.fetch }
    it 'returns efficiency report' do
      expect(collect_keys subject).to include(:efficiency_22,
                                              :efficiency_percent)
    end
  end

  # Narrowing Parameters

  describe '#order_by' do
    describe '<invalid value>' do
      subject { client.activities.order_by(:invalid).fetch }
      it 'raises an InvalidQueryError' do
        expect { subject }.to raise_error(Rescuetime::InvalidQueryError)
      end
    end
    describe ':rank' do
      subject { collect_keys client.activities.order_by(:rank).fetch }
      it { is_expected.to include(:rank) }
    end
    describe ':time' do
      subject { collect_keys client.activities.order_by(:time).fetch }
      it { is_expected.to include(:date) }

      describe 'interval:' do
        describe '<invalid value>' do
          subject { client.overview.order_by(:time, interval: :invalid).fetch }
          it 'raises an InvalidQueryError' do
            expect { subject }.to raise_error(Rescuetime::InvalidQueryError)
          end
        end
        describe ':minute' do
          subject { client.overview.order_by(:time, interval: :minute).fetch }
          it 'segmented in 5-minute chunks' do
            time = unique_dates subject
            seconds = 60 * 5
            expect(time[1] - time[0]).to eq(seconds)
          end
        end
        describe ':hour' do
          subject { client.overview.date('2015-05-02').order_by(:time, interval: :hour).fetch }
          it 'segmented in 1-hour chunks' do
            time = unique_dates subject
            seconds = 60 * 60
            expect(time[1] - time[0]).to eq(seconds)
          end
        end
        describe ':day' do
          subject do
            client.efficiency.order_by(:time, interval: :day)
                .from('2015-04-28').to('2015-05-03').fetch
          end
          it 'segmented in 1-day chunks' do
            time = unique_dates subject
            seconds = 60 * 60 * 24
            expect(time[1] - time[0]).to eq(seconds)
          end
        end
        describe ':week' do
          subject do
            client.efficiency.order_by(:time, interval: :week)
                .from('2015-01-01').fetch
          end
          it 'segmented in 1-week chunks' do
            time = unique_dates subject
            seconds = 60 * 60 * 24 * 7
            expect(time[1] - time[0]).to eq(seconds)
          end
        end
        describe ':month' do
          subject do
            client.efficiency.order_by(:time, interval: :month)
                .from('2015-01-01').to('2015-05-03').fetch
          end
          it 'segmented in 1-month chunks' do
            time = unique_dates subject
            day = 60 * 60 * 24
            min, max = (day * 27), (day * 32)
            expect(time[1] - time[0]).to be_between(min, max)
          end
        end
      end
    end
    describe ':member' do
      subject { collect_keys client.activities.order_by(:member).fetch }
      it { is_expected.to include(:person) }
    end
  end

  describe '#date' do
    subject { client.overview.order_by(:time).date('2015-05-01').fetch }
    it 'restricts report to a single date' do
      wrong_days = count_invalid subject, /2015-05-01/, :date
      expect(wrong_days).to eq(0)
    end
    describe '<invalid value>' do
      subject { client.overview.date('invalid date').fetch }
      it 'raises an InvalidQueryError' do
        expect { subject }.to raise_error(Rescuetime::InvalidQueryError)
      end
    end
    describe '<String: YYYY-MM-DD>' do
      subject { client.overview.order_by(:time).date('2015-05-01').fetch }
      it 'returns content for YYYY-MM-DD' do
        wrong_days = count_invalid subject, /2015-05-01/, :date
        expect(wrong_days).to eq(0)
      end
    end
    describe '<String: YYYY/MM/DD>' do
      subject { client.overview.order_by(:time).date('2015/05/01').fetch }
      it 'returns content for YYYY/MM/DD' do
        wrong_days = count_invalid subject, /2015-05-01/, :date
        expect(wrong_days).to eq(0)
      end
    end
    describe '<String: MM-DD-YYYY>' do
      subject { client.overview.order_by(:time).date('05-01-2015').fetch }
      it 'returns content for MM-DD-YYYY' do
        wrong_days = count_invalid subject, /2015-05-01/, :date
        expect(wrong_days).to eq(0)
      end
    end
    describe '<String: MM/DD/YYYY>' do
      subject { client.overview.order_by(:time).date('05/01/2015').fetch }
      it 'returns content for MM/DD/YYYY' do
        wrong_days = count_invalid subject, /2015-05-01/, :date
        expect(wrong_days).to eq(0)
      end
    end
    describe '<String: MM-DD>' do
      subject { client.overview.order_by(:time).date('05-01').fetch }
      it 'returns content for MM-DD for the current year' do
        wrong_days = count_invalid subject, /2015-05-01/, :date
        expect(wrong_days).to eq(0)
      end
    end
    describe '<String: MM/DD>' do
      subject { client.overview.order_by(:time).date('05/01').fetch }
      it 'returns content for MM/DD for the current year' do
        wrong_days = count_invalid subject, /2015-05-01/, :date
        expect(wrong_days).to eq(0)
      end
    end
    describe '<Object#strftime>' do
      subject do
        client.overview.order_by(:time)
            .date(Time.new(2015, 05, 01)).fetch
      end
      it 'returns content for date-like object' do
        wrong_days = count_invalid subject, /2015-05-01/, :date
        expect(wrong_days).to eq(0)
      end
    end
  end
  describe '#to and #from' do
    subject do
      client.overview.order_by(:time)
          .from('2015-05-02').to('2015-05-03')
          .fetch
    end

    it 'sets report start and end dates' do
      wrong_days = count_invalid subject, /2015-05-0(2|3)/, :date
      expect(wrong_days).to eq(0)
    end
    describe 'just #from' do
      subject { client.overview.order_by(:time).from(Date.today.prev_day).fetch }
      it 'sets end date to today' do
        valid = [Date.today, Date.today.prev_day]
                  .map { |e| e.strftime('%Y-%m-%d') }.join('|')
        wrong_days = count_invalid subject, /#{valid}/, :date
        expect(wrong_days).to eq(0)
      end
    end
    describe '<invalid value>' do
      subject { client.overview.to('invalid').from('invalid').fetch }
      it 'raises an InvalidQueryError' do
        expect { subject }.to raise_error(Rescuetime::InvalidQueryError)
      end
    end
  end

  describe '#where' do
    describe 'name:' do
      describe '<activity>' do
        subject { client.activities.where(name: 'rubymine').fetch }
        it 'returns documents within an activity' do
          documents = subject.collect { |e| e[:activity] }
                          .select { |e| e =~ /\w+\.\w+ - \w+/i }
          expect(documents.count).to be > 1
        end
        describe 'document: <document>' do
          let(:doc_name) do
            'reportable_spec.rb - rescuetime - [~/GitHub/rescuetime]'
          end
          subject do
            client.activities.where(date: '2015-05-03',
                                    name: 'rubymine',
                                    document: doc_name ).fetch
          end
          its(:length) { is_expected.to eq(1) }
        end
      end
      describe '<category>' do
        subject { client.categories.where(name: 'Editing & IDEs').fetch }
        it 'returns activities within a category' do
          expect(collect_keys subject).to include(:activity, :category,
                                                  :productivity)
          expect(count_invalid subject, /Editing & IDEs/, :category).to eq(0)
        end
      end
      describe '<overview>' do
        subject { client.overview.where(name: 'Software Development').fetch }
        it 'returns categories within an overview' do
          expect(collect_keys subject).to include(:activity, :category,
                                                  :productivity)
        end
      end
    end
  end

  # Processing Parameters

  describe '#format' do
    describe '<invalid value>' do
      subject { client.overview.format(:invalid).fetch }
      it 'raises an InvalidFormatError' do
        expect { subject }.to raise_error(Rescuetime::InvalidFormatError)
      end
    end
    describe ':array' do
      subject { client.overview.format(:array).fetch }
      it { is_expected.to be_an Array}
    end
    describe ':cvs' do
      subject { client.overview.format(:csv).fetch }
      it { is_expected.to be_a CSV }
    end
  end
end
