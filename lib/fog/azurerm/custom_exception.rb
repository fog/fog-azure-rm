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
      end

      def to_s
        puts "#{@body}"
      end
    end
  end
end