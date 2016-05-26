# frozen_string_literal: true

require 'rescuetime/core_extensions/object/blank'

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
    }.freeze

    class << self
      # Performs the GET request to the specified host. Before making the
      # request, it checks for API key presence and raises an exception if it
      # is not present. All other exceptions require the request to go through.
      #
      # @param  [String] host    request host
      # @param  [Hash]   params  request parameters
      # @return [String]
      #
      # @raise [Rescuetime::Errors::MissingCredentialsError] if no api key is present
      # @raise [Rescuetime::Errors::InvalidCredentialsError] if api key is incorrect
      # @raise [Rescuetime::Errors::InvalidQueryError]       if query is badly formed
      # @raise [Rescuetime::Errors::Error]                   if response HTTP status is
      #                                              not 200
      #
      # @see http://ruby-doc.org/stdlib/libdoc/net/http/rdoc/Net/HTTP.html#method-c-get_response
      #      Net::HTTP.get_response
      # @see Rescuetime::Client#api_key=
      def get(host, params)
        # guard clause: fail if no API key is present
        params[:key].extend CoreExtensions::Object::Blank
        params[:key].present? || raise(Rescuetime::Errors::MissingCredentialsError)

        uri = set_uri host, params
        response = Net::HTTP.get_response uri

        fail_or_return_body response
      end

      private

      # Takes a host and collection of parameters and returns the associated
      # URI object. Required for the Net::HTTP.get_response method.
      #
      # @param  [String] host    target API endpoint
      # @param  [Hash]   params  collection of query parameters
      # @return [URI]            URI object with host and query parameters
      #
      # @see Requester#get
      # @see http://ruby-doc.org/stdlib/libdoc/net/http/rdoc/Net/HTTP.html#method-c-get_response
      #      Net::HTTP.get_response
      # @since v0.3.3
      def set_uri(host, params)
        # delete params with empty values
        req_params = params.delete_if do |_key, value|
          # type conversion required because symbols/ints can't be extended
          value = value.to_s.extend CoreExtensions::Object::Blank
          value.blank?
        end

        uri       = URI(host)
        uri.query = URI.encode_www_form(req_params)
        uri
      end

      # Checks for an error in the Rescuetime response. If an error was recieved
      # raise the appropriate Rescuetime::Errors::Error. Otherwise, return the response.
      #
      # @param  [Net::HTTPResponse] response   HTTP response from rescuetime.com
      # @return [String]            valid response body
      #
      # @raise [Rescuetime::Errors::InvalidCredentialsError] if api key is incorrect
      # @raise [Rescuetime::Errors::InvalidQueryError]       if query is badly formed
      # @raise [Rescuetime::Errors::Error] an error that varies based on the
      #                             response status
      def fail_or_return_body(response)
        # match the response body to known error messages with 200 status
        case response.body
        when key_not_found? then raise Rescuetime::Errors::InvalidCredentialsError
        when invalid_query? then raise Rescuetime::Errors::InvalidQueryError
        end

        # check the response status for errors
        status = response.code.to_i
        error = Rescuetime::Errors::Error::CODES[status]
        raise(error) if error

        response.body
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
