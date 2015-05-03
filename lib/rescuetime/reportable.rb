module Rescuetime
  # The Rescuetime::Reportable module contains client methods relating to
  # generating requests to fetch reports on the /data endpoint of the
  # Data Analytics API.
  #
  # @since v0.1.0
  module Reportable
    # @since v0.3.0
    def overview
      @query.restrict_kind = 'overview'
      self
    end

    # @since v0.3.0
    def categories
      @query.restrict_kind = 'category'
      self
    end

    # @since v0.1.0
    def activities
      @query.restrict_kind = 'activity'
      self
    end

    # @since v0.2.0
    def productivity
      @query.restrict_kind = 'productivity'
      self
    end

    # @since v0.2.0
    def efficiency
      @query.restrict_kind = 'efficiency'
      @query.perspective = 'interval'
      self
    end

    # @since v0.3.0
    def order_by(type, options = {})
      fail(InvalidQueryError, "valid values: #{QUERY_VALS[:order_by]} /(#{type} submitted)") unless
          QUERY_VALS[:order_by].include? type
      fail(InvalidQueryError, "valid values: #{QUERY_VALS[:interval]} /(#{options[:interval]} submitted)") if
          options[:interval] && ! QUERY_VALS[:interval].include?(options[:interval])
      @query.perspective = type.to_s == 'time' ? 'interval' : type.to_s
      @query.resolution_time = options[:interval] || options['interval']
      self
    end

    # @since v0.3.0
    def date(date)
      @query.restrict_begin = to_formatted_s date
      @query.restrict_end   = to_formatted_s date
      self
    end

    # @since v0.3.0
    def from(date)
      @query.restrict_begin = to_formatted_s date
      self
    end

    # @since v0.3.0
    def to(date)
      @query.restrict_end   = to_formatted_s date
      self
    end

    # @since v0.3.0
    def where(options)
      @query.restrict_thing = options[:name]
      @query.restrict_thingy = options[:document]
      self
    end

    # @since v0.3.0
    def format(format)
      @format = format
      self
    end

    private

    QUERY_VALS = {
      order_by: [:time, :rank, :member],
      interval: [:minute, :hour, :day, :week, :month]
    }

    # @since v0.3.0
    def to_formatted_s(date)
      case
        when date.respond_to?(:strftime)    then date.strftime('%Y-%m-%d')
        when date =~ /\d{4}-\d{2}-\d{2}/    then date
        when date =~ /\d{4}\/\d{2}\/\d{2}/  then date.gsub '/', '-'
        when date =~ /\d{2}[-\/]\d{2}[-\/]\d{4}/
          date_chunks = date.scan(/\d+/)
          "#{ date_chunks[2] }-#{ date_chunks[0] }-#{ date_chunks[1] }"
        when date =~ /\d{2}[-\/]\d{2}/
          date_chunks = date.scan(/\d+/)
          "#{ Time.now.year }-#{ date_chunks[0] }-#{ date_chunks[1] }"
        else
          fail InvalidQueryError,
               'invalid date format (see documentaiton for valid formats)'
      end
    end
  end
end
