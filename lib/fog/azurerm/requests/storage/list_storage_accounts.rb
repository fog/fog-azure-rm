module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def list_storage_accounts
          begin
            promise = @storage_mgmt_client.storage_accounts.list
            response = promise.value!
            body = response.body.value
            body.each do |obj|
              obj.properties.last_geo_failover_time = DateTime.parse(Time.now.to_s)
            end
            result = Azure::ARM::Storage::Models::StorageAccountListResult.serialize_object(response.body)['value']
            result
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Exception listing Storage Accounts. #{e.body['error']['message']}"
            raise msg
          end
        end
      end
      # This class provides the mock implementation for unit tests.
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
