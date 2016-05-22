module Rescuetime
  # The Rescuetime::Requestable module contains client methods relating to
  # sending HTTP requests
  #
  # @since v0.2.0
  class Requester
    # Contains bodies of error responses recieved from rescuetime.com. If one
    # of these responses is recieved, an error will be raised.
    INVALID = {
      key_not_found: '"error":"# key not found","messages":"key not found"',
      query: '"error": "# query error",'\
      '"messages": "Error: Likely a badly formatted or missing parameter"'
    }

    class << self
      # Performs the GET request to the specified host. Before making the
      # request, it checks for API key presence and raises an exception if it
      # is not present. All other exceptions require the request to go through.
      #
      # @param  [String] host    request host
      # @param  [Hash]   params  request parameters
      # @param  [#get]   http    HTTP requester
      # @return [Faraday::Response]
      #
      # @raise [Rescuetime::MissingCredentialsError] if no api key is present
      # @raise [Rescuetime::InvalidCredentialsError] if api key is incorrect
      # @raise [Rescuetime::InvalidQueryError]       if query is badly formed
      # @raise [Rescuetime::Error]                   if response HTTP status is
      #                                              not 200
      #
      # @see Rescuetime::Client#api_key=
      def get(host, params, http: Faraday)
        # Fail if no api key is provided
        unless params[:key] && !params[:key].to_s.empty?
          fail(Rescuetime::MissingCredentialsError)
        end

        req_params = params.delete_if { |_, v| !v || v.to_s.empty? }
        response = http.get host, req_params

        fail_or_return response
      end

      private

      # Checks for an error in the Rescuetime response. If an error was recieved
      # raise the appropriate Rescuetime::Error. Otherwise, return the response.
      #
      # @param  [Faraday::Response] response   HTTP response from rescuetime.com
      # @return [Faraday::Response] 200 HTTP response from rescuetime.com
      #
      # @raise [Rescuetime::InvalidCredentialsError] if api key is incorrect
      # @raise [Rescuetime::InvalidQueryError]       if query is badly formed
      # @raise [Rescuetime::Error] an error that varies based on the
      #                             response status
      def fail_or_return(response)
        # match the response body to known error messages with 200 status
        case response.body
        when key_not_found? then fail Rescuetime::InvalidCredentialsError
        when invalid_query? then fail Rescuetime::InvalidQueryError
        end

        # check the response status for errors
        error = Rescuetime::Error::CODES[response.status.to_i]
        fail(error) if error

        response
      end

      # Returns lambda that returns true if the response body states that the
      # api key was not found. For use in a case statement.
      #
      # This check is required because rescuetime.com returns a staus of 200
      # with this error.
      #
      # @return [Lambda] a lambda that returns true if the api key was not found
      #
      # @see Rescuetime::Requester::INVALID
      # @since v0.3.2
      def key_not_found?
        ->(body) { body =~ /#{INVALID[:key_not_found]}/ }
      end

      # Returns lambda that returns true if the response body states that the
      # query was invalid. For user in a case statement.
      #
      # This check is required because rescuetime.com returns a staus of 200
      # with this error.
      #
      # @return [Lambda] a lambda that returns true if the query was invalid
      #
      # @see Rescuetime::Requester::INVALID
      # @since v0.3.2
      def invalid_query?
        ->(body) { body =~ /#{INVALID[:query]}/ }
      end
    end
  end
end
