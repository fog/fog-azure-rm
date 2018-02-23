module Fog
  module AzureRM
    class NetworkAdapter
      def self.get(url, token)
        create_faraday_connection

        create_faraday_request(url, token, nil, GET_METHOD)
      end

      def self.put(url, token, body)
        create_faraday_connection

        create_faraday_request(url, token, body, PUT_METHOD)
      end

      def self.delete(url, token)
        create_faraday_connection

        create_faraday_request(url, token, nil, DELETE_METHOD)
      end

      private

      def self.create_faraday_connection
        @connection = Faraday.new(url: AZURE_RESOURCE)
      end

      def self.create_faraday_request(url, token, body, method_type)
        response = @connection.send(method_type, url) do |request|
          request.headers['accept'] = 'application/json'
          request.headers['Content-type'] = 'application/json'
          request.headers['authorization'] = token
          request.body = body.nil? ? '{}' : body
        end
      end
    end
  end
end
