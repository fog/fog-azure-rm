module Fog
  module AzureRM
    class CustomException < StandardError
      attr_accessor :request
      attr_accessor :response
      attr_accessor :body
      attr_accessor :error_message
      attr_accessor :error_code

      def initialize(exception)
        @request = exception.env.request
        @response = exception.env.response
        @body = JSON.decode(exception.env.body)
        @error_message = @body['error']['message']
        @error_code = @body['error']['code']
        super
      end

      def to_s
        exception = {}
        
        exception['message'] = @error_message
        exception['code'] = @error_code
        exception['body'] = @body
        exception['request'] = @request
        exception['response'] = @response

        Fog::JSON.encode(exception)
      end
    end
  end
end