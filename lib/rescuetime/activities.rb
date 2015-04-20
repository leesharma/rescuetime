module Rescuetime
  # The Rescuetime::Activities module contains client methods relating to user
  # activities on the /data endpoint of the Data Analytics API.
  #
  # @since v0.1.0
  module Activities
    # Base URL for RescueTime Data Analytics API endpoint
    BASE_URL = 'https://www.rescuetime.com/anapi/data'

    # Returns array of all activities. The default request is equivalent to @client.activities restrict_kind: 'activity'
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
    #
    #   @client.activities({ restrict_kind: 'productivity' })
    #   # =>  [
    #   #       { :rank=>1, :time_spent_seconds=>6956, :number_of_people=>1, :productivity=>2 },
    #   #       { :rank=>2, :time_spent_seconds=>2635, :number_of_people=>1, :productivity=>-2 },
    #   #       { :rank=>3, :time_spent_seconds=>2415, :number_of_people=>1, :productivity=>1 },
    #   #       { :rank=>4, :time_spent_seconds=>1210, :number_of_people=>1, :productivity=>0 },
    #   #       { :rank=>5, :time_spent_seconds=>93, :number_of_people=>1, :productivity=>-1 }
    #   #     ]
    #
    # @param [Hash] options Query parameters to be passed to RescueTime
    # @option options [String] :restrict_kind
    #   Restricts the level of detail and/or kind of report returned
    #   1. 'overview': sums statistics for all activities into their top level category
    #   2. 'category': sums statistics for all activities into their sub category
    #   3. 'activity': sums statistics for individual applications / web sites / activities
    #   4. 'productivity': productivity calculation
    #   5. 'efficiency': efficiency calculation (not applicable in "rank" perspective)
    # @return [Array<Hash>]
    # @since v0.1.0
    def activities(options={})
      connection = Faraday.new(Rescuetime::Activities::BASE_URL)
      params = { key: @api_key,
                 format: 'csv',
                 version: 0,
                 operation: 'select' }
      response = connection.get '', params.merge(options)

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