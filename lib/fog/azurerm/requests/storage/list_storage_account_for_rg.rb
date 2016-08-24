module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def list_storage_account_for_rg(resource_group)
          msg = "Listing Storage Accounts in Resource Group #{resource_group}."
          Fog::Logger.debug msg
          begin
            result = @storage_mgmt_client.storage_accounts.list_by_resource_group(resource_group)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          result.value
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def list_storage_account_for_rg(resource_group)
          [
            {
              'id' => "/subscriptions/{subscriptionId}/resourceGroups/#{resource_group}/providers/Microsoft.Storage/storageAccounts/mock_test_storage_account",
              'name' => 'mock_test_storage_account',
              'type' => 'Microsoft.Storage/storageAccounts',
              'location' => 'westus',
              'tags' => {},
              'properties' =>
              {
                'provisioningState' => 'Succeeded',
                'accountType' => 'Standard_LRS',
                'primaryEndpoints' =>
                  {
                    'blob' => 'https://mock_test_storage_account.blob.core.windows.net/',
                    'queue' => 'https://mock_test_storage_account.queue.core.windows.net/',
                    'table' => 'https://mock_test_storage_account.table.core.windows.net/',
                    'file' => 'https://mock_test_storage_account.file.core.windows.net/'
                  },
                'primaryLocation' => 'westus',
                'statusOfPrimary' => 'available',
                'lastGeoFailoverTime' => '2016-05-19T09:58:55Z',
                'creationTime' => '2016-05-19T05:24:36Z'
              }
            }
          ]
        end
      end
    end
  end
end
