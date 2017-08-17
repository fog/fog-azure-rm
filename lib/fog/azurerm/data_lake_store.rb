module Fog
  module DataLakeStore
    # This class registers models, requests and collections
    class AzureRM < Fog::Service
      requires :tenant_id
      requires :client_id
      requires :client_secret
      requires :subscription_id

      request_path 'fog/azurerm/requests/data_lake_store'
      request :create_data_lake_store_account
      request :update_data_lake_store_account
      request :delete_data_lake_store_account
      request :check_for_data_lake_store_account
      request :list_data_lake_store_accounts
      request :get_data_lake_store_account

      model_path 'fog/azurerm/models/data_lake_store'
      model :data_lake_store_account
      collection :data_lake_store_accounts
      model :encryption_config
      model :key_vault_meta_info
      model :firewall_rule

      # This class provides the mock implementation for unit tests.
      class Mock
        def initialize(_options = {})
        end
      end

      # This class provides the actual implemention for service calls.
      class Real
        def initialize(options)
          begin
            require 'azure_mgmt_datalake_store'
          rescue LoadError => e
            retry if require('rubygems')
            raise e.message
          end

          credentials = Fog::Credentials::AzureRM.get_credentials(options[:tenant_id], options[:client_id], options[:client_secret])
          @data_lake_store_account_client = ::Azure::ARM::DataLakeStore::DataLakeStoreAccountManagementClient.new(credentials)
          @data_lake_store_account_client.subscription_id = options[:subscription_id]
          @tenant_id = options[:tenant_id]
          @client_id = options[:client_id]
          @client_secret = options[:client_secret]
          @resources = Fog::Resources::AzureRM.new(
              tenant_id: options[:tenant_id],
              client_id: options[:client_id],
              client_secret: options[:client_secret],
              subscription_id: options[:subscription_id]
          )
        end
      end
    end
  end
end
