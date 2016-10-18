module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def update_storage_account(storage_account_hash)
          msg = "Updating Storage Account: #{storage_account_hash[:name]} in Resource Group #{storage_account_hash[:resource_group]}."
          Fog::Logger.debug msg
          storage_account_params = get_storage_account_update_params(storage_account_hash)
          begin
            storage_account = @storage_mgmt_client.storage_accounts.update(storage_account_hash[:resource_group],
                                                                           storage_account_hash[:name],
                                                                           storage_account_params)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug 'Storage Account updated successfully.'
          storage_account
        end

        private

        def get_storage_account_update_params(storage_account_hash)
          params = Azure::ARM::Storage::Models::StorageAccountUpdateParameters.new
          sku = Azure::ARM::Storage::Models::Sku.new
          sku.name = "#{storage_account_hash[:sku_name]}_#{storage_account_hash[:replication]}"
          params.sku = sku
          unless storage_account_hash[:encryption].nil?
            encryption = Azure::ARM::Storage::Models::Encryption.new
            encryption_services = Azure::ARM::Storage::Models::EncryptionServices.new
            encryption_service = Azure::ARM::Storage::Models::EncryptionService.new
            encryption_service.enabled = storage_account_hash[:encryption]
            if encryption_service.enabled
              encryption_service.last_enabled_time = Time.new
            end
            encryption_services.blob = encryption_service
            encryption.services = encryption_services
            params.encryption = encryption
          end
          params
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def update_storage_account(*)
          storage_account_hash = {
            'id' => '/subscriptions/67f2116d-4ea2-4c6c-b20a-f92183dbe3cb/resourceGroups/fog_test_rg/providers/Microsoft.Storage/storageAccounts/fogtestsasecond',
            'name' => 'fog-test-storage-account',
            'location' => 'west us',
            'sku' =>
              {
                'name' => 'Standard_LRS'
              }
          }
          storage_account_mapper = Azure::ARM::Storage::Models::StorageAccount.mapper
          storage_mgmt_client.deserialize(storage_account_mapper, storage_account_hash, 'hash')
        end
      end
    end
  end
end
