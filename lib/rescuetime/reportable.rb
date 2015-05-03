module Rescuetime
  # The Rescuetime::Reportable module contains client methods relating to
  # generating requests to fetch reports on the /data endpoint of the
  # Data Analytics API.
  #
  # @since v0.1.0
  module Reportable
    # Base URL for RescueTime Data Analytics API endpoint
    # @since v0.1.0
    BASE_HOST = 'https://www.rescuetime.com/anapi/data'

    # Returns array of all activities.
    #
    # @return [Array<Hash>]
    #
    # @raise [Rescuetime::MissingCredentials] if the Rescuetime::Client has
    #   no set api key
    # @raise [Rescuetime::InvalidCredentials] if the provided api key is
    #   rejected by RescueTime
    # @since v0.1.0
    def activities(options = {})
      response = self.get BASE_HOST, options.merge(detail: 'activity')

      case options[:format]
      when 'csv' then CSV.new(response.body, headers: true)
      else array_of_hashes_from_csv(response.body)
      end
    end

    # Returns efficiency report. Equivalent to
    #   #activities(by: time, detail: efficiency)
    # @see #activities valid options
    #
    # @param [Hash] options options hash (same as #activities)
    # @return [Array<Hash>]
    def efficiency(options = {})
      self.activities({by: 'time'}.merge(options.merge(detail: 'efficiency')))
    end

    # Returns overview report.
    #
    # @see #activities valid options
    #
    # @param [Hash] options options hash (same as #activities)
    # @return [Array<Hash>]
    def overviews(options = {})
      self.activities(options.merge(detail: 'overview'))
    end

    # Returns categories report.
    #
    # @see #activities valid options
    #
    # @param [Hash] options options hash (same as #activities)
    # @return [Array<Hash>]
    def categories(options = {})
      self.activities(options.merge(detail: 'category'))
    end

    # Returns productivity report.
    #
    # @param [Hash] options options hash (same as #activities)
    # @return [Array<Hash>]
    def productivity(options = {})
      self.activities(options.merge(detail: 'productivity'))
    end

    private

    # Takes a CSV with headers and returns an array of hashes
    #
    # @param body[CSV] the original CSV file
    # @return [Array] an array of hashes, containing keys of the CSV headers
    # @since v0.1.0
    def array_of_hashes_from_csv(body)
      activities = CSV.new(body,
                           headers: true,
                           header_converters: :symbol,
                           converters: :all)

      activities.to_a.map(&:to_hash)
    end
  end
end
