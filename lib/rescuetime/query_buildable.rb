require 'rescuetime/date_parser'

module Rescuetime
  # The Rescuetime::Reportable module contains client methods relating to
  # generating requests to fetch reports on the /data endpoint of the
  # Data Analytics API.
  #
  # @since v0.1.0
  module QueryBuildable
    # Parameters that are included by default in every query
    BASE_PARAMS = { format:     'csv',
                    operation:  'select',
                    version:    0 }

    # Valid values for the :order and :interval parameters
    # @see #order_by
    VALID = {
      order_by: %w(time rank member),
      interval: %w(minute hour day week month)
    }

    # Returns a Rescuetime overview report, grouping activities into their
    # top-level categories
    #
    # Defaults:
    # - order: rank
    # - date range: current day
    #
    # @example Basic Use
    #   client = Rescuetime::Client.new
    #   client.overview
    #   #=> #<Rescuetime::Collection:0x007f93841681a8>
    #
    # @return [Rescuetime::Collection] a Rescuetime Collection specifying kind
    #                                  as an overview report
    #
    # @see #categories   Category report (alternative)
    # @see #activities   Activity report (alternative)
    # @see #productivity Productivity report (alternative)
    # @see #efficiency   Efficiency report (alternative)
    # @see https://www.rescuetime.com/apidoc#paramlist  Rescuetime API docs
    #                                                   (see: restrict_kind)
    def overview
      add_to_query restrict_kind: 'overview'
    end

    # Returns a Rescuetime category report, grouping activities into their
    # second-level (sub-)categories
    #
    # Defaults:
    # - order: rank
    # - date range: current day
    #
    # @example Basic Use
    #   client = Rescuetime::Client.new
    #   client.categories
    #   #=> #<Rescuetime::Collection:0x007f93841681a8>
    #
    # @return [Rescuetime::Collection] a Rescuetime Collection specifying kind
    #                                  as a category report
    #
    # @see #overview     Overview report (alternative)
    # @see #activities   Activity report (alternative)
    # @see #productivity Productivity report (alternative)
    # @see #efficiency   Efficiency report (alternative)
    # @see https://www.rescuetime.com/apidoc#paramlist  Rescuetime API docs
    #                                                   (see: restrict_kind)
    def categories
      add_to_query restrict_kind: 'category'
    end

    # Returns a Rescuetime activity report, grouping activities by their
    # specific application, website, or activity
    #
    # Defaults:
    # - order: rank
    # - date range: current day
    #
    # @example Basic Use
    #   client = Rescuetime::Client.new
    #   client.activities
    #   #=> #<Rescuetime::Collection:0x007f93841681a8>
    #
    # @return [Rescuetime::Collection] a Rescuetime Collection specifying kind
    #                                  as a activity report
    #
    # @see #overview     Overview report (alternative)
    # @see #categories   Category report (alternative)
    # @see #productivity Productivity report (alternative)
    # @see #efficiency   Efficiency report (alternative)
    # @see https://www.rescuetime.com/apidoc#paramlist  Rescuetime API docs
    #                                                   (see: restrict_kind)
    def activities
      add_to_query restrict_kind: 'activity'
    end

    # Returns a Rescuetime productivity report, featuring productivity
    # calculations
    #
    # Defaults:
    # - order: rank
    # - date range: current day
    #
    # @example Basic Use
    #   client = Rescuetime::Client.new
    #   client.productivity
    #   #=> #<Rescuetime::Collection:0x007f93841681a8>
    #
    # @return [Rescuetime::Collection] a Rescuetime Collection specifying kind
    #                                  as a productivity report
    #
    # @see #overview     Overview report (alternative)
    # @see #categories   Category report (alternative)
    # @see #activities   Activity report (alternative)
    # @see #efficiency   Efficiency report (alternative)
    # @see https://www.rescuetime.com/apidoc#paramlist  Rescuetime API docs
    #                                                   (see: restrict_kind)
    def productivity
      add_to_query restrict_kind: 'productivity'
    end

    # Returns a Rescuetime efficiency report, featuring efficiency calculations.
    # Defaults to chronological (time) order.
    #
    # Defaults:
    # - order: time
    # - date range: current day
    #
    # @example Basic Use
    #   client = Rescuetime::Client.new
    #   client.efficiency
    #   #=> #<Rescuetime::Collection:0x007f93841681a8>
    #
    # @return [Rescuetime::Collection] a Rescuetime Collection specifying kind
    #                                  as a efficiency report
    #
    # @see #overview     Overview report (alternative)
    # @see #categories   Category report (alternative)
    # @see #activities   Activity report (alternative)
    # @see #productivity Productivity report (alternative)
    # @see https://www.rescuetime.com/apidoc#paramlist  Rescuetime API docs
    #                                                   (see: restrict_kind)
    def efficiency
      add_to_query restrict_kind: 'efficiency',
                   perspective:   'interval'
    end

    # Specifies the ordering and the interval of the returned Rescuetime report.
    # For example, the results can be ordered by time, activity rank, or member;
    # The results can be returned in intervals spanning a month, a week, a day,
    # an hour, or 5-minutes.
    #
    # Efficiency reports default to :time order; everything else defaults to
    # :rank order.
    #
    # @example Basic Use
    #   client = Rescuetime::Client.new
    #   client.order_by 'time' # interval is not required
    #   #=> #<Rescuetime::Collection:0x007f93841681a8>
    #
    #   client.order_by 'rank', interval: 'hour'
    #   #=> #<Rescuetime::Collection:0x007f93841681a8>
    #
    #   client.order_by :rank, interval: :hour # Symbols are also valid
    #   #=> #<Rescuetime::Collection:0x007f93841681a8>
    #
    # @example Invalid Values Raise Errors
    #   client = Rescuetime::Client.new
    #   client.order_by 'invalid'
    #   # => Rescuetime::InvalidQueryError: invalid is not a valid order
    #
    #   client.order_by 'time', interval: 'invalid'
    #   # => Rescuetime::InvalidQueryError: invalid is not a valid interval
    #
    # @param  [#to_s]        order      an order for the results (ex. 'time')
    # @param  [#intern, nil] interval   a chunking interval for results
    #                                   (ex. 'month'). defaults to nil
    #
    # @return [Rescuetime::Collection]  a Rescuetime Collection specifying order
    #                                   and interval (if set)
    #
    # @raise [Rescuetime::InvalidQueryError] if either order or interval are
    #                                        invalid
    #
    # @see https://www.rescuetime.com/apidoc#paramlist  Rescuetime API docs
    #                                                   (see: perspective,
    #                                                   resolution_time)
    # @see Rescuetime::QueryBuildable::VALID            List of valid values
    def order_by(order, interval: nil)
      # set order and intervals as symbols
      order    = order.to_s
      interval = interval ? interval.to_s : nil

      # guards against invalid order or interval
      unless valid_order? order
        fail InvalidQueryError, "#{order} is not a valid order"
      end

      unless valid_interval? interval
        fail InvalidQueryError, "#{interval} is not a valid interval"
      end

      add_to_query perspective: (order == 'time' ? 'interval' : order),
                   resolution_time: interval
    end

    # Limits the Rescuetime report to a specific single date. To specify a date
    # range, use #from and #to.
    #
    # @example Basic Use
    #   client = Rescuetime::Client.new
    #   client.date Date.parse('1776-07-04')
    #   #=> #<Rescuetime::Collection:0x007f93841681a8>
    #
    # @example Valid Date Formats
    #   client.date Time.parse('1776-07-04') # responds to #strftime
    #   client.date '1776-07-04'
    #   client.date '1776/07/04'
    #   client.date '07-04-1776'
    #   client.date '07/04/1776'
    #   client.date '07-04' # defaults to current year
    #   client.date '07/04' # defaults to current year
    #
    # @param  [#strftime, String]      date  a valid date-like object
    # @return [Rescuetime::Collection]       a Rescuetime Collection specifying
    #                                        report date
    #
    # @raise [Rescuetime::InvalidQueryError] if the date format is invalid
    #
    # @see #from
    # @see #to
    # @see Rescuetime::DateParser
    # @see Rescuetime::DateParser::DATE_FORMATS         Valid date formats
    # @see https://www.rescuetime.com/apidoc#paramlist  Rescuetime API docs
    #                                                   (see: restrict_begin,
    #                                                   restrict_end)
    # @since v0.3.0
    def date(date)
      add_to_query restrict_end:    to_formatted_s(date),
                   restrict_begin:  to_formatted_s(date)
    end

    # Limits the Rescuetime report to a specific start date. If the end date is
    # not specified, it defaults to today.
    #
    # @example Basic Use
    #   client = Rescuetime::Client.new
    #   client.from 3.days.ago
    #   #=> #<Rescuetime::Collection:0x007f93841681a8>
    #
    # @example With a specified end date
    #   client.from(2.weeks.ago).to(1.week.ago)
    #   client.from(2.weeks.ago) # defaults to ending today
    #
    # @param  [#strftime, String]      date  a valid date-like object
    # @return [Rescuetime::Collection]       a Rescuetime Collection specifying
    #                                        report date
    #
    # @raise [Rescuetime::InvalidQueryError] if the date format is invalid
    #
    # @see #to
    # @see #date
    # @see Rescuetime::DateParser
    # @see Rescuetime::DateParser::DATE_FORMATS         Valid date formats
    # @see https://www.rescuetime.com/apidoc#paramlist  Rescuetime API docs
    #                                                   (see: restrict_begin)
    # @since v0.3.0
    def from(date)
      add_to_query restrict_begin:  to_formatted_s(date)
    end

    # Limits the Rescuetime report to a specific end date. Requires #from to
    # be set before the query is sent, but it doesn't matter if that happens
    # before or after the call to #to.
    #
    # @example Basic Use
    #   client = Rescuetime::Client.new
    #   client.from(3.days.ago).to(1.day.ago)
    #   #=> #<Rescuetime::Collection:0x007f93841681a8>
    #
    # @example Requires a specified start date
    #   client.from(2.weeks.ago).to(1.week.ago).all # valid
    #   #=> [ ... ]
    #
    #   client.to(1.week.ago).from(2.weeks.ago).all # valid
    #   #=> [ ... ]
    #
    #   client.to(1.week.ago).all                   # invalid!
    #   #=> Rescuetime::InvalidQueryError
    #
    # @param  [#strftime, String]      date  a valid date-like object
    # @return [Rescuetime::Collection]       a Rescuetime Collection specifying
    #                                        report date
    #
    # @raise [Rescuetime::InvalidQueryError] if the date format is invalid
    #
    # @see #from
    # @see #date
    # @see Rescuetime::DateParser
    # @see Rescuetime::DateParser::DATE_FORMATS         Valid date formats
    # @see https://www.rescuetime.com/apidoc#paramlist  Rescuetime API docs
    #                                                   (see: restrict_end)
    # @since v0.3.0
    def to(date)
      add_to_query restrict_end:    to_formatted_s(date)
    end

    # Limits the Rescuetime report to specific activities and documents.
    # The name option limits the results to those where name is an exact match;
    # this can be used on the overview, activity, and category report. The
    # document option limits the specific document title; this is only available
    # on the activity report.
    #
    # If a value is passed for an unsupported report, it will be ignored.
    #
    # To see the category and document names for your account, please look at
    # your rescuetime dashboard or generated rescuetime report.
    #
    # :name can be used on:
    # - Overview report
    # - Category report
    # - Activity report
    #
    # :document can be used on:
    # - Activity report when :name is set
    #
    # @example Basic Use
    #   client = Rescuetime::Client.new
    #   client.activities.where name: 'github.com',
    #                           document: 'leesharma/rescuetime'
    #   #=> #<Rescuetime::Collection:0x007f93841681a8>
    #
    # @example Valid reports
    #   client.overview.where name: 'Utilities'
    #   client.categories.where name: 'Intelligence'
    #   client.activities.where name: 'github.com'
    #   client.activities.where name: 'github.com', document: 'rails/rails'
    #
    # @example Invalid reports
    #   client.productivity.where name: 'Intelligence'  # Invalid!
    #   client.efficiency.where name: 'Intelligence'    # Invalid!
    #   client.activities.where document: 'rails/rails' # Invalid!
    #
    # @param  [String] name      Rescuetime category name, valid on overview,
    #                            category, and activity reports
    # @param  [String] document  Specific document name, valid on activity
    #                            reports when :name is set
    #
    # @return [Rescuetime::Collection]  a Rescuetime Collection specifying
    #                                   category name and (optionally) document
    # @raises [ArgumentError] if name is not set
    #
    # @see #overview
    # @see #activities
    # @see #categories
    # @see https://www.rescuetime.com/apidoc#paramlist  Rescuetime API docs
    #                                                   (see: restrict_thing,
    #                                                   restrict_thingy)
    # @since v0.3.0
    def where(name: nil, document: nil)
      # Stand-in for required keyword arguments
      name or fail ArgumentError, 'missing keyword: name'

      add_to_query restrict_thing:  name,
                   restrict_thingy: document
    end

    private

    # Adds terms to the Rescuetime collection query
    #
    # @param  [Hash] terms             a set of terms to add to the query
    # @return [Rescuetime::Collection]
    def add_to_query(**terms)
      if self.is_a? Rescuetime::Collection
        self << terms
        self
      else
        Rescuetime::Collection.new(BASE_PARAMS, state, terms)
      end
    end

    # Returns a list of valid orders
    #
    # @return [Array<String>] a list of valid order arguments
    # @since v0.3.3
    def valid_orders
      VALID[:order_by]
    end

    # Returns a list of valid intervals
    #
    # @return [Array<String>] a list of valid interval arguments
    # @since v0.3.3
    def valid_intervals
      VALID[:interval]
    end

    # Returns true if the given order is valid
    #
    # @param  [#to_s]   order order to check for validity
    # @return [Boolean]       true if the order is valid
    # @since v0.3.3
    def valid_order?(order)
      valid_orders.include? order.to_s
    end

    # Returns true if the given interval is valid.
    #
    # @param  [#to_s]   interval interval to check for validity
    # @return [Boolean]          true if the interval is valid
    # @since v0.3.3
    def valid_interval?(interval)
      return true if interval.nil? # intervals aren't required
      valid_intervals.include? interval.to_s
    end

    # Returns a string in the Rescuetime-date format ("YYYY-MM-DD")
    #
    # @param  [#strftime, String] date
    # @param  [#parse]            date_parser  defaults to
    #                                          Rescuetime::DateParser
    # @return [String]            a string in 'YYYY-MM-DD' format
    #
    # @raise [Rescuetime::InvalidQueryError] if the date format is invalid
    #
    # @see Rescuetime::DateParser
    # @see Rescuetime::DateParser::DATE_FORMATS         Valid date formats
    # @since v0.3.0
    def to_formatted_s(date, date_parser: Rescuetime::DateParser)
      date_parser.parse(date)
    end
  end
end
