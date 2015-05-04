module Rescuetime
  # The Rescuetime::Requestable module contains client methods relating to
  # sending HTTP requests
  #
  # @since v0.2.0
  class Requester
    class << self
      # @since v0.2.0
      def get(host, params)
        fail(Rescuetime::MissingCredentialsError) unless
          params[:key] && !params[:key].to_s.empty?

        response = Faraday.get(host,
                               params.delete_if { |_, v| !v || v.to_s.empty? })

        fail_or_return response
      end

      private

      INVALID = {
        key_not_found: '"error":"# key not found","messages":"key not found"',
        query: '"error": "# query error",'\
            '"messages": "Error: Likely a badly formatted or missing parameter"'
      }

      def fail_or_return(response)
        fail Rescuetime::InvalidCredentialsError if
          response.body =~ /#{INVALID[:key_not_found]}/
        fail Rescuetime::InvalidQueryError if
          response.body =~ /#{INVALID[:query]}/

        error = Rescuetime::Error::CODES[response.status.to_i]
        fail(error) if error

        response
      end
    end
  end
end
