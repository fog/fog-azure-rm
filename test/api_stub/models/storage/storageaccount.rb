module ApiStub
  module Models
    module Storage
      class StorageAccount
        def self.create_storage_account
          {
              'location' => 'west us',
              'properties' => {
                  'accountType' => 'Standard_LRS'
              }
          }
        end

      def self.delete_storage_account
        storage_acc_obj = Azure::ARM::Storage::Models::StorageAccount.new
        storage_acc_obj.id = '1'
        storage_acc_obj.name = 'fog-test-storage-account'
        storage_acc_obj.type = ''
        storage_acc_obj.location = 'west us'
        storage_acc_obj.tags = {}
        storage_acc_obj.properties = {}
        storage_acc_obj
      end

      def self.list_storage_account
        { 'id'=>'/subscriptions/67f2116d-4ea2-4c6c-b20a-f92183dbe3cb/resourceGroups/fog_test_rg/providers/Microsoft.Storage/storageAccounts/fogtestsasecond',
          'name'=>'fog-test-storage-account',
          'location'=>"westus",
          'properties'=>
              {
                  'accountType'=>'Standard_LRS'
              }
        }
      end


      end
    end
  end
end
