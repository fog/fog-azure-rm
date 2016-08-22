module ApiStub
  module Models
    module Storage
      # Mock class for Storage Account
      class StorageAccount
        def self.create_storage_account(client)
          result = {
            'id' => '/subscriptions/67f2116d-4ea2-4c6c-b20a-f92183dbe3cb/resourceGroups/fog_test_rg/providers/Microsoft.Storage/storageAccounts/fogtestsasecond',
            'name' => 'fog-test-storage-account',
            'location' => 'west us',
            'sku' =>
              {
                'name' => 'Standard_LRS'
              }
          }
          mapper = Azure::ARM::Storage::Models::StorageAccount.mapper
          client.deserialize(mapper, result, 'hash')
        end
      end
    end
  end
end
