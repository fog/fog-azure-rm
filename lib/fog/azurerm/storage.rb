require 'fog/azurerm/core'
module Fog
  module Storage
    # This class registers models, requests and collections
    class AzureRM < Fog::Service
      recognizes :tenant_id
      recognizes :client_id
      recognizes :client_secret
      recognizes :subscription_id

      recognizes :azure_storage_account_name
      recognizes :azure_storage_access_key

      request_path 'fog/azurerm/requests/storage'
      request :create_storage_account
      request :list_storage_accounts
      request :delete_storage_account
      request :list_storage_account_for_rg
      request :check_storage_account_name_availability
      request :delete_disk
      request :get_blob_metadata
      request :get_container_metadata
      request :set_blob_metadata
      request :set_container_metadata

      model_path 'fog/azurerm/models/storage'
      model :storage_account
      collection :storage_accounts
      model :data_disk
      model :container
      collection :containers
      model :blob
      collection :blobs

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
          unless credentials.nil?
            @storage_mgmt_client = ::Azure::ARM::Storage::StorageManagementClient.new(credentials)
            @storage_mgmt_client.subscription_id = options[:subscription_id]
          end

          if Fog::Credentials::AzureRM.new_account_credential? options
            client_obj = ::Azure::Storage::Client.new(storage_account_name: options[:azure_storage_account_name],
                                                      storage_access_key: options[:azure_storage_access_key])
            # Create an azure storage blob service object after you set up the credentials
            @blob_client = ::Azure::Storage::Blob::BlobService.new(client: client_obj)
            # Add retry filter to the service object
            @blob_client.with_filter(Azure::Storage::Core::Filter::ExponentialRetryPolicyFilter.new)
          end
        end
      end
    end
  end
end
