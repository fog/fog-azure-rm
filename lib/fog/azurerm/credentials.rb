module Fog
  module Credentials
    # This class is managing credentials token
    class AzureRM
      def self.get_credentials(tenant_id, client_id, client_secret)
        if @credentials.nil? || new_client(tenant_id, client_id, client_secret)
          get_new_credentials(tenant_id, client_id, client_secret)
        else
          @credentials
        end
      end

      def self.get_token(tenant_id, client_id, client_secret)
        get_credentials(tenant_id, client_id, client_secret) if @credentials.nil?
        @token_provider.get_authentication_header
      end

      def self.get_new_credentials(tenant_id, client_id, client_secret)
        @tenant_id = tenant_id
        @client_id = client_id
        @client_secret = client_secret
        @token_provider = MsRestAzure::ApplicationTokenProvider.new(@tenant_id, @client_id, @client_secret)
        @credentials = MsRest::TokenCredentials.new(@token_provider)
        @credentials
      end

      def self.new_client(tenant_id, client_id, client_secret)
        @tenant_id != tenant_id ||
          @client_id != client_id ||
          @client_secret != client_secret
      end

      private_class_method :get_new_credentials
      private_class_method :new_client
    end
  end
end
