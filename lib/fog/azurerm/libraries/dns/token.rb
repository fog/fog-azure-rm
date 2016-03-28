require 'rest_client'
require 'json'
require ::File.expand_path('../../constants', __FILE__)

module Fog
  module DNS
    module Libraries
      class Token
        def initialize(tenant_id, client_id, client_secret, http_proxy = nil)
          @tenant_id = tenant_id
          @client_id = client_id
          @client_secret = client_secret
          @http_proxy = http_proxy
        end

        def generate_token
          login_url = "#{AZURE_LOGIN_URL}/#{@tenant_id}/oauth2/token"
          RestClient.proxy = @http_proxy unless @http_proxy.nil?

          begin
            token_response = RestClient.post(
              login_url,
              client_id: @client_id,
              client_secret: @client_secret,
              grant_type: AZURE_GRANT_TYPE,
              resource: "#{AZURE_RESOURCE}/")
            token_hash = JSON.parse(token_response)
            token = 'Bearer ' + token_hash['access_token']
            return token
          rescue RestClient::Exception => e
            body = JSON.parse(e.http_body)
            msg = "Exception trying to retrieve the token: #{body['error']}, #{body['error_description']}"
            fail msg
          end
        end
      end
    end
  end
end
