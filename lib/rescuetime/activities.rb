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

    # Returns array of all activities.
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
    # @example Set level of detail
    #   @client.activities(detail: 'overview')[0]
    #   # => { :rank=>1, :time_spent_seconds=>13140, :number_of_people=>1, :category=>'Software Development' }
    #
    #   @client.activities(detail: 'category')[0]
    #   # => { :rank=>1, :time_spent_seconds=>5835, :number_of_people=>1, :category=>'Editing and IDEs' }
    #
    #   @client.activities(detail: 'activity')[0]
    #   # => { :rank=>1,
    #   #      :time_spent_seconds=>5835,
    #   #      :number_of_people=>1,
    #   #      :category=>'Editing and IDEs',
    #   #      :activity=>'RubyMine',
    #   #      :productivity=>2 }
    #
    #   @activities = @client.activities(detail: 'productivity')
    #   # =>  [
    #   #       { :rank=>1, :time_spent_seconds=>6956, :number_of_people=>1, :productivity=>2 },
    #   #       { :rank=>2, :time_spent_seconds=>2635, :number_of_people=>1, :productivity=>-2 },
    #   #       { :rank=>3, :time_spent_seconds=>2415, :number_of_people=>1, :productivity=>1 },
    #   #       { :rank=>4, :time_spent_seconds=>1210, :number_of_people=>1, :productivity=>0 },
    #   #       { :rank=>5, :time_spent_seconds=>93, :number_of_people=>1, :productivity=>-1 }
    #   #     ]
    #
    # @example Set perspective
    #   @client.activities(by: 'rank')     # Returns activities by rank (time spent per activity)
    #   @client.activities(by: 'interval') # Returns activities chronologically
    #   @client.activities(by: 'member')   # Returns activities grouped by member
    #
    # @example Format
    #   @client.activities                # Returns array of hashes
    #   @client.activities format: 'csv'  # Returns Mime::CSV
    #
    # @param [Hash] options Query parameters to be passed to RescueTime
    # @option options [String] :detail
    #   Restricts the level of detail of report returned
    #   1. 'overview': sums statistics for all activities into their top level category
    #   2. 'category': sums statistics for all activities into their sub category
    #   3. 'activity' (default): sums statistics for individual applications / web sites / activities
    #   4. 'productivity': productivity calculation
    #   5. 'efficiency': efficiency calculation (not applicable in "rank" perspective)
    # @option options [String] :by
    #   Lets you set the perspective of your report
    #   1. 'rank' (default): returns a ranked report of activities by total time spent
    #   2. 'time': returns a chronological report of activities
    #   3. 'member': returns an activity report grouped by member
    # @option options [String] :format
    #   Lets you specify a return type for your report
    #   1. default: returns an array of hashes with symbolized keys
    #   2. 'csv': returns a Mime::CSV object
    #
    # @return [Array<Hash>]
    #
    # @raise [Rescuetime::MissingCredentials] if the Rescuetime::Client has no set api key
    # @raise [Rescuetime::InvalidCredentials] if the provided api key is rejected by RescueTime
    # @since v0.1.0
    def activities(options={})
      response = self.get BASE_URL, options

      case options[:format]
        when 'csv' then CSV.new(response.body, headers: true)
        else array_of_hashes_from_csv(response.body)
      end
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
    # @return [Hash] productivity levels, with integers from -2 to 2 as keys
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
    def array_of_hashes_from_csv(body)
      activities = CSV.new(body,
                           headers: true,
                           header_converters: :symbol,
                           converters: :all)

      activities.to_a.map(&:to_hash)
    end
  end
end