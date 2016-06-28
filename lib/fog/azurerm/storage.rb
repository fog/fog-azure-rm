require 'fog/azurerm/core'
module Fog
  module Storage
    # This class registers models, requests and collections
    class AzureRM < Fog::Service
      requires :tenant_id
      requires :client_id
      requires :client_secret
      requires :subscription_id

      request_path 'fog/azurerm/requests/storage'
      request :create_storage_account
      request :list_storage_accounts
      request :delete_storage_account
      request :list_storage_account_for_rg
      request :check_storage_account_name_availability
      request :delete_disk

      model_path 'fog/azurerm/models/storage'
      model :storage_account
      collection :storage_accounts
      model :data_disk

      # This class provides the mock implementation for unit tests.
      class Mock
        def initialize(_options = {})
          begin
            require 'azure_mgmt_storage'
          rescue LoadError => e
            retry if require('rubygems')
            raise e.message
          end
        end
      end
      # This class provides the actual implemention for service calls.
      class Real
        def initialize(options)
          begin
            require 'azure_mgmt_storage'
            require 'azure/storage'
          rescue LoadError => e
            retry if require('rubygems')
            raise e.message
          end

          credentials = Fog::Credentials::AzureRM.get_credentials(options[:tenant_id], options[:client_id], options[:client_secret])
          @storage_mgmt_client = ::Azure::ARM::Storage::StorageManagementClient.new(credentials)
          @storage_mgmt_client.subscription_id = options[:subscription_id]
        end
      end
    end
  end
end
