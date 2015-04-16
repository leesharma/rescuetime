module Rescuetime
  # The Rescuetime::Activities module contains client methods relating to user
  # activities on the /data endpoint of the Data Analytics API.
  #
  # @since v0.1.0
  module Activities
    # Base URL for RescueTime Data Analytics API endpoint
    BASE_URL = 'https://www.rescuetime.com/anapi/data'

    # Returns array of all activities.
    #
    # @example
    #   @client.activities.class     # => Array
    #   @client.acitvities[0].class  # => Hash
    #
    #   @client.activities[0]
    #   # =>  {
    #   #       :rank=>1,
    #   #       :time_spent_seconds=>5307,
    #   #       :number_of_people=>1,
    #   #       :activity=>"github.com",
    #   #       :category=>"General Software Development",
    #   #       :productivity=>2
    #   #     }
    # @return [Array<Hash>]
    # @since v0.1.0
    def activities
      connection = Faraday.new(Rescuetime::Activities::BASE_URL)
      options = { key: @api_key,
                  format: 'csv' }
      response = connection.get '', options

      activities_from_csv response.body
    end

    private

    # Takes a CSV with headers and returns an array of hashes
    #
    # @param body[CSV] the original CSV file
    # @return [Array] an array of hashes, containing keys of the CSV headers
    def activities_from_csv(body)
      activities = CSV.new(body,
                           headers: true,
                           header_converters: :symbol,
                           converters: :all)

      activities.to_a.map(&:to_hash)
    end
  end
end