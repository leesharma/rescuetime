module Rescuetime::Formatters
  # A fake formatter for testing purposes
  class FakeFormatter < BaseFormatter
    def self.name
      'fake'
    end

    def self.format(_report)
      nil
    end
  end
end
