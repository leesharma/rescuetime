module Rescuetime
  # The Rescuetime::Requestable module contains client methods relating to
  # sending HTTP requests
  #
  # @since v0.2.0
  class Requester
    class << self
      INVALID = {
          key_not_found:  /"error":"# key not found","messages":"key not found"/,
          query:  /"error": "# query error","messages": "Error: Likely a badly formatted or missing parameter"/
      }

      # @since v0.2.0
      def get(host, params)
        fail(Rescuetime::MissingCredentialsError) unless params[:key] && !params[:key].to_s.empty?

        response = Faraday.get(host,
                               params.delete_if { |_, v| !v || v.to_s.empty? })
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

      private

      def fail_or_return(response)
        error = Rescuetime::Error::HTTP_ERRORS[response.status.to_i]
        fail(error) if error
        response
      end
    end
  end
end
