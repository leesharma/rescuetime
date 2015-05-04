module Rescuetime
  # The Rescuetime::Reportable module contains client methods relating to
  # generating requests to fetch reports on the /data endpoint of the
  # Data Analytics API.
  #
  # @since v0.1.0
  module QueryBuildable
    BASE_PARAMS = { format:     'csv',
                    operation:  'select',
                    version:    0 }

    # @return [Rescuetime::Collection]
    def overview
      add_to_query restrict_kind: 'overview'
    end

    # @return [Rescuetime::Collection]
    def categories
      add_to_query restrict_kind: 'category'
    end

    # @return [Rescuetime::Collection]
    def activities
      add_to_query restrict_kind: 'activity'
    end

    # @return [Rescuetime::Collection]
    def productivity
      add_to_query restrict_kind: 'productivity'
    end

    # @return [Rescuetime::Collection]
    def efficiency
      add_to_query restrict_kind: 'efficiency',
                   perspective: 'interval'
    end

    # @return [Rescuetime::Collection]=
    def order_by(order, opts = {})
      fail(InvalidQueryError, "#{order} is not a valid order") unless
          VALID[:order_by].include? order
      fail(InvalidQueryError, "#{opts[:interval]} is not a valid interval") if
          opts[:interval] && !VALID[:interval].include?(opts[:interval])

      add_to_query perspective: (order.to_s == 'time' ? 'interval' : order),
                   resolution_time: opts[:interval] || opts['interval']
    end

    # @return [Rescuetime::Collection]
    # @since v0.3.0
    def date(date)
      add_to_query restrict_end:    to_formatted_s(date),
                   restrict_begin:  to_formatted_s(date)
    end

    # @return [Rescuetime::Collection]
    # @since v0.3.0
    def from(date)
      add_to_query restrict_begin:  to_formatted_s(date)
    end

    # @return [Rescuetime::Collection]
    # @since v0.3.0
    def to(date)
      add_to_query restrict_end:    to_formatted_s(date)
    end

    # @return [Rescuetime::Collection]
    # @since v0.3.0
    def where(options)
      add_to_query restrict_thing:  options[:name],
                   restrict_thingy: options[:document]
    end

    private

    VALID = {
      order_by: [:time, :rank, :member],
      interval: [:minute, :hour, :day, :week, :month]
    }

    def add_to_query(**terms)
      if self.is_a? Rescuetime::Collection
        self << terms
        self
      else
        Rescuetime::Collection.new(BASE_PARAMS, state, terms)
      end
    end

    # @since v0.3.0
    def to_formatted_s(date)
      case
      when date.respond_to?(:strftime)      then date.strftime('%Y-%m-%d')
      when date =~ /\d{4}-\d{2}-\d{2}/      then date
      when date =~ %r{\d{4}\/\d{2}\/\d{2}}  then date.gsub '/', '-'
      when date =~ %r{\d{2}[-\/]\d{2}[-\/]\d{4}/}
        date_chunks = date.scan(/\d+/)
        "#{ date_chunks[2] }-#{ date_chunks[0] }-#{ date_chunks[1] }"
      when date =~ %r{\d{2}[-\/]\d{2}}
        date_chunks = date.scan(/\d+/)
        "#{ Time.now.year }-#{ date_chunks[0] }-#{ date_chunks[1] }"
      else
        fail InvalidQueryError,
             'Invalid date entered. Please see docs for allowed formats.'
      end
    end
  end
end
