module ApiStub
  module Models
    module Storage
      class StorageAccount
        def self.create_storage_account
          {
            'location' => 'west us',
            'properties' =>
              {
                'accountType' => 'Standard_LRS'
              }
          }
        end

        def self.list_storage_account
          {
            'id' => '/subscriptions/67f2116d-4ea2-4c6c-b20a-f92183dbe3cb/resourceGroups/fog_test_rg/providers/Microsoft.Storage/storageAccounts/fogtestsasecond',
            'name' => 'fog-test-storage-account',
            'location' => 'westus',
            'properties' =>
              {
                'accountType' => 'Standard_LRS'
              }
          }
        end
      end
    end
  end
end
