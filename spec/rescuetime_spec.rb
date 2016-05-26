require 'spec_helper'

describe Rescuetime do
  it 'has a version number' do
    expect(Rescuetime::VERSION).not_to be nil
  end

  describe '.configure' do
    before :each do
      Rescuetime.configure do |config|
        relative_path = '../fixtures/formatters/fake_formatter.rb'
        config.formatter_paths = [File.expand_path(relative_path, __FILE__)]
      end
    end

    it 'loads formatters from the in-gem formatter path' do
      formatters = Rescuetime::ReportFormatters.new.all
      expect(formatters).to include 'csv'
      expect(formatters).to include 'array'
    end

    it 'loads formatters from the user-specified path', focus: true do
      formatters = Rescuetime::ReportFormatters.new.all
      expect(formatters).to include 'fake'
    end

    after :each do
      Rescuetime.reset
    end
  end

  describe '.reset' do
    before :each do
      Rescuetime.configure do |config|
        config.formatter_paths = ['custom paths']
      end
    end

    it 'resets the configuration' do
      Rescuetime.reset
      config = Rescuetime.configuration

      expect(config.formatter_paths).to eq []
    end
  end

  describe '.configuration' do
    it 'returns a Rescuetime::Configuration' do
      config = Rescuetime.configuration
      expect(config).to be_a Rescuetime::Configuration
    end

    it 'returns the configuration set by .config' do
      Rescuetime.configure { |c| c.formatter_paths = ['path'] }
      config = Rescuetime.configuration
      expect(config.formatter_paths).to eq ['path']
    end
  end
end
