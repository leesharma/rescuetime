module Rescuetime
  # The Rescuetime::Requestable module contains client methods relating to
  # sending HTTP requests
  #
  # @since v0.2.0
  module HTTPRequestable
    private

    # @since v0.2.0
    DEFAULT_OPTIONS = { format: 'csv', version: 0, operation: 'select' }

    INVALID = {
        key_not_found:  /"error":"# key not found","messages":"key not found"/,
        query:  /"error": "# query error","messages": "Error: Likely a badly formatted or missing parameter"/
    }

    # @since v0.2.0
    def get
      fail(Rescuetime::MissingCredentialsError) unless api_key?

      query = Hash[@query.each_pair.to_a].delete_if { |_, v| !v || v.empty? }
      response = @connection.get('', query
                                     .merge(DEFAULT_OPTIONS)
                                     .merge(key: @api_key))

      case
      when response.body =~ INVALID[:key_not_found]
        fail Rescuetime::InvalidCredentialsError,
             JSON.parse(response.body)['message']
      when response.body =~ INVALID[:query]
        fail Rescuetime::InvalidQueryError,
             JSON.parse(response.body)['message']
      else
        fail_or_return response
      end
    end

    def fail_or_return(response)
      error = Rescuetime::Error::HTTP_ERRORS[response.status.to_i]
      fail(error) if error
      response
    end
  end
end
