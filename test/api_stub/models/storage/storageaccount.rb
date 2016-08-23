module ApiStub
  module Models
    module Storage
      # Mock class for Storage Account
      class StorageAccount
        def self.create_storage_account(storage_mgmt_client)
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
