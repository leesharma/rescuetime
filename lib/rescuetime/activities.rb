module Rescuetime
  module Activities

    BASE_URL = 'https://www.rescuetime.com/anapi/data'
    # Returns array of all activities.
    #
    # @return [Array<Hash>]
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
    # @param body[CSV]
    # @return [Array]
    def activities_from_csv(body)
      activities = CSV.new(body,
                           headers: true,
                           header_converters: :symbol,
                           converters: :all)

      activities.to_a.map(&:to_hash)
    end
  end
end