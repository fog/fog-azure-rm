module Fog
  module KeyVault
    # This class registers models, requests and collections
    class AzureRM < Fog::Service
      requires :tenant_id
      requires :client_id
      requires :client_secret
      requires :subscription_id

      request_path 'fog/azurerm/requests/key_vault'
      request :get_vault
      request :list_vaults
      request :create_or_update_vault
      request :delete_vault
      request :check_vault_exists

      model_path 'fog/azurerm/models/key_vault'
      model :vault
      model :access_policy_entry
      collection :vaults

      # This class provides the mock implementation for unit tests.
      class Mock
        def initialize(_options = {})
          begin
            require 'azure_mgmt_key_vault'
          rescue LoadError => e
            retry if require('rubygems')
            raise e.message
          end
        end
      end

      # This class provides the actual implementation for service calls.
      class Real
        def initialize(options)
          begin
            require 'azure_mgmt_key_vault'
          rescue LoadError => e
            retry if require('rubygems')
            raise e.message
          end

          credentials = Fog::Credentials::AzureRM.get_credentials(options[:tenant_id], options[:client_id], options[:client_secret])
          @key_vault_client = ::Azure::ARM::KeyVault::KeyVaultManagementClient.new(credentials)
          @key_vault_client.subscription_id = options[:subscription_id]
        end
      end
    end
  end
end
