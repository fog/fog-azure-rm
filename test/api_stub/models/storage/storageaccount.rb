module ApiStub
  module Models
    module Storage
      # Mock class for Storage Account
      class StorageAccount
        def self.create_storage_account
          {
            'location' => 'west us',
            'properties' =>
              {
                'accountType' => 'Standard'
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

        def self.standard_lrs(service)
          storage_obj = Fog::Storage::AzureRM::StorageAccount.new(
            name: 'storage-account',
            location: 'West US',
            resource_group: 'fog-test-rg',
            account_type: 'Other',
            replication: 'LRS',
            service: service
          )
          storage_obj
        end

        def self.standard_check_for_invalid_replications(service)
          storage_obj = Fog::Storage::AzureRM::StorageAccount.new(
            name: 'storage-account',
            location: 'West US',
            resource_group: 'fog-test-rg',
            account_type: 'Standard',
            replication: 'HGDKS',
            service: service
          )
          storage_obj
        end

        def self.premium_check_for_invalid_replications(service)
          storage_obj = Fog::Storage::AzureRM::StorageAccount.new(
            name: 'storage-account',
            location: 'West US',
            resource_group: 'fog-test-rg',
            account_type: 'Premium',
            replication: 'HGDKS',
            service: service
          )
          storage_obj
        end
      end
    end
  end
end
