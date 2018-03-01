module Fog
  module AzureRM
    class NetworkAdapter
      def self.get(url, token)
        send_request(url, token, nil, GET_METHOD)
      end

      def self.put(url, token, body)
        send_request(url, token, body, PUT_METHOD)
      end

      def self.delete(url, token)
        send_request(url, token, nil, DELETE_METHOD)
      end

      private

      def self.send_request(url, token, body, method_type)
        connection = Faraday.new

        response = connection.send(method_type, url) do |request|
          request.headers['accept'] = 'application/json'
          request.headers['Content-type'] = 'application/json'
          request.headers['authorization'] = token
          request.body = body.nil? ? '{}' : body
        end
      end
    end
  end
end
