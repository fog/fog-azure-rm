module Fog
  module Credentials
    # This class is managing credentials token
    class AzureRM
      def self.get_credentials(tenant_id, client_id, client_secret)
        if @credentials.nil? || new_management_credential?(tenant_id, client_id, client_secret)
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
        return if @tenant_id.nil? || @client_id.nil? || @client_secret.nil?
        @token_provider = MsRestAzure::ApplicationTokenProvider.new(@tenant_id, @client_id, @client_secret, active_directory_service_settings)
        @credentials = MsRest::TokenCredentials.new(@token_provider)
        @credentials
      end

      def self.new_management_credential?(tenant_id, client_id, client_secret)
        @tenant_id != tenant_id ||
          @client_id != client_id ||
          @client_secret != client_secret
      end

      def self.new_account_credential?(options = {})
        @account_name != options[:azure_storage_account_name] ||
          @account_key != options[:azure_storage_access_key] ||
          @connection_string != options[:azure_storage_connection_string]
      end

      private_class_method :get_new_credentials
      private_class_method :new_management_credential?
    end
  end
end
