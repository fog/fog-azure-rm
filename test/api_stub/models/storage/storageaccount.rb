module ApiStub
  module Models
    module Storage
      class StorageAccount

        def self.create_storage_account
          storage_acc_obj = Azure::ARM::Storage::Models::StorageAccount.new
          storage_acc_obj.id = '1'
          storage_acc_obj.name = 'fog-test-storage-account'
          storage_acc_obj.type = ''
          storage_acc_obj.location = 'west us'
          storage_acc_obj.tags = {}
          storage_acc_obj.properties = {}
          storage_acc_obj
        end
      end
    end
  end
end
