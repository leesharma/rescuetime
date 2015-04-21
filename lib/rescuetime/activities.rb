module Rescuetime
  # The Rescuetime::Activities module contains client methods relating to user
  # activities on the /data endpoint of the Data Analytics API.
  #
  # @since v0.1.0
  module Activities
    # Base URL for RescueTime Data Analytics API endpoint
    # @since v0.1.0
    BASE_URL = 'https://www.rescuetime.com/anapi/data'
    # Map of numeric productivity levels to meaning
    # @since v0.2.0
    PRODUCTIVITY_LEVELS = { -2  => 'Very Unproductive',
                            -1  => 'Unproductive',
                            0   => 'Neutral',
                            1   => 'Productive',
                            2   => 'Very Productive' }

    # Returns array of all activities. The default request is equivalent to @client.activities restrict_kind: 'activity'
    #
    # @example Basic behavior
    #   @activities = @client.activities
    #   @activities.class     # => Array
    #   @acitvities[0].class  # => Hash
    #
    #   @activities[0]
    #   # =>  {
    #   #       :rank=>1,
    #   #       :time_spent_seconds=>5307,
    #   #       :number_of_people=>1,
    #   #       :activity=>"github.com",
    #   #       :category=>"General Software Development",
    #   #       :productivity=>2
    #   #     }
    #
    # @example Restrict by kind
    #   @client.activities(restrict_kind: 'overview')[0]
    #   # => { :rank=>1, :time_spent_seconds=>13140, :number_of_people=>1, :category=>'Software Development' }
    #
    #   @client.activities(restrict_kind: 'category')[0]
    #   # => { :rank=>1, :time_spent_seconds=>5835, :number_of_people=>1, :category=>'Editing and IDEs' }
    #
    #   @client.activities(restrict_kind: 'activity')[0]
    #   # => { :rank=>1,
    #   #      :time_spent_seconds=>5835,
    #   #      :number_of_people=>1,
    #   #      :category=>'Editing and IDEs',
    #   #      :activity=>'RubyMine',
    #   #      :productivity=>2 }
    #
    #   @activities = @client.activities(restrict_kind: 'productivity')
    #   # =>  [
    #   #       { :rank=>1, :time_spent_seconds=>6956, :number_of_people=>1, :productivity=>2 },
    #   #       { :rank=>2, :time_spent_seconds=>2635, :number_of_people=>1, :productivity=>-2 },
    #   #       { :rank=>3, :time_spent_seconds=>2415, :number_of_people=>1, :productivity=>1 },
    #   #       { :rank=>4, :time_spent_seconds=>1210, :number_of_people=>1, :productivity=>0 },
    #   #       { :rank=>5, :time_spent_seconds=>93, :number_of_people=>1, :productivity=>-1 }
    #   #     ]
    #
    # @example Perspective
    #   @client.activities(perspective: 'rank')     # Returns activities by rank (time spent per activity)
    #   @client.activities(perspective: 'interval') # Returns activities chronologically
    #   @client.activities(perspective: 'member')   # Returns activities grouped by member
    #
    # @param [Hash] options Query parameters to be passed to RescueTime
    # @option options [String] :restrict_kind
    #   Restricts the level of detail and/or kind of report returned
    #   1. 'overview': sums statistics for all activities into their top level category
    #   2. 'category': sums statistics for all activities into their sub category
    #   3. 'activity': sums statistics for individual applications / web sites / activities
    #   4. 'productivity': productivity calculation
    #   5. 'efficiency': efficiency calculation (not applicable in "rank" perspective)
    #
    # @return [Array<Hash>]
    #
    # @raise [Rescuetime::MissingCredentials] if the Rescuetime::Client has no set api key
    # @raise [Rescuetime::InvalidCredentials] if the provided api key is rejected by RescueTime
    # @since v0.1.0
    def activities(options={})
      response = self.get BASE_URL, options
      activities_from_csv response.body
    end

    # Returns map of numeric productivity levels to meaning
    #
    # @example
    #   @activity = @client.activities(restrict_kind: 'productivity')[0]
    #   @primary_productivity = @client.productivity_levels[@activity[:productivity]]
    #
    #   puts "I have spent most of my time being #{@primary_productivity}."
    #   # => I have spent most of my time being Very Productive.
    #
    # @return [Hash]
    # @since v0.2.0
    def productivity_levels
      PRODUCTIVITY_LEVELS
    end

    private

    # Takes a CSV with headers and returns an array of hashes
    #
    # @param body[CSV] the original CSV file
    # @return [Array] an array of hashes, containing keys of the CSV headers
    # @since v0.1.0
    def activities_from_csv(body)
      activities = CSV.new(body,
                           headers: true,
                           header_converters: :symbol,
                           converters: :all)

      activities.to_a.map(&:to_hash)
    end
  end
end