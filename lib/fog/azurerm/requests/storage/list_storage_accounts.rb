module Fog
  module Storage
    class AzureRM
      class Real
        def list_storage_accounts
          response = @storage_mgmt_client.storage_accounts.list
          result = response.value!
          result.body.value
        end
      end

      class Mock
        def list_storage_accounts
          storage_acc = ::Azure::ARM::Storage::Models::StorageAccount.new
          storage_acc.name = 'fog-test-storage-account'
          storage_acc.location = 'West US'
          [storage_acc]
        end
      end
    end
  end
end
