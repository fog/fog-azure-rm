module Fog
  module Credentials
    # This class is managing credentials token
    class AzureRM
      def self.get_credentials(tenant_id, client_id, client_secret, environment = ENVIRONMENT_AZURE_CLOUD)
        if @credentials.nil? || new_management_credential?(tenant_id, client_id, client_secret, environment)
          get_new_credentials(tenant_id, client_id, client_secret, environment)
        else
          @credentials
        end
      end

      def self.get_token(tenant_id, client_id, client_secret, environment = ENVIRONMENT_AZURE_CLOUD)
        get_credentials(tenant_id, client_id, client_secret, environment) if @credentials.nil?
        @token_provider.get_authentication_header
      end

      def self.get_new_credentials(tenant_id, client_id, client_secret, environment)
        @tenant_id = tenant_id
        @client_id = client_id
        @client_secret = client_secret
        @environment = environment
        return if @tenant_id.nil? || @client_id.nil? || @client_secret.nil?
        @token_provider = MsRestAzure::ApplicationTokenProvider.new(@tenant_id, @client_id, @client_secret, active_directory_service_settings(environment))
        @credentials = MsRest::TokenCredentials.new(@token_provider)
        @credentials
      end

      def self.new_management_credential?(tenant_id, client_id, client_secret, environment)
        @tenant_id != tenant_id ||
          @client_id != client_id ||
          @client_secret != client_secret ||
          @environment != environment
      end

      private_class_method :get_new_credentials
      private_class_method :new_management_credential?
    end
  end
end
