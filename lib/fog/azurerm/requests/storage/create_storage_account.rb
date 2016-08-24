module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def create_storage_account(storage_account_hash)
          msg = "Creating Storage Account: #{storage_account_hash[:name]} in Resource Group #{storage_account_hash[:resource_group]}."
          Fog::Logger.debug msg
          storage_account_params = get_storage_account_params(storage_account_hash[:sku_name],
                                                              storage_account_hash[:location],
                                                              storage_account_hash[:replication])
          begin
            storage_account = @storage_mgmt_client.storage_accounts.create(storage_account_hash[:resource_group],
                                                                    storage_account_hash[:name],
                                                                    storage_account_params)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug 'Storage Account created successfully.'
          storage_account
        end

        private

        def get_storage_account_params(sku_name, location, replication)
          params = Azure::ARM::Storage::Models::StorageAccountCreateParameters.new
          sku = Azure::ARM::Storage::Models::Sku.new
          sku.name = "#{sku_name}_#{replication}"
          params.sku = sku
          params.kind = Azure::ARM::Storage::Models::Kind::Storage
          params.location = location
          params
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def create_storage_account(*)
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
