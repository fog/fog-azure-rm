module Fog
  module DataLakeStore
    class AzureRM
      # Real class for DNS Request
      class Real
        def list_data_lake_store_accounts
          msg = 'Getting list of Data Lake Store Accounts.'
          Fog::Logger.debug msg
          begin
            accounts = @data_lake_store_account_client.account.list
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          accounts
        end

        private

        def list_data_lake_store_accounts_by_rg(resource_group)
          msg = "Getting list of Data Lake Store Accounts in Resource Group #{resource_group}."
          Fog::Logger.debug msg
          begin
            accounts = @data_lake_store_account_client.account.list_by_resource_group(resource_group)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          accounts
        end
      end

      # Mock class for DNS Request
      class Mock
        def list_data_lake_store_accounts
          [
              {
                  'id' => '/subscriptions/########-####-####-####-############/resourceGroups/resource_group/providers/Microsoft.DataLakeStore/accounts/name',
                  'name' => 'name1',
                  'type' => 'Microsoft.DataLakeStore/accounts',
                  'etag' => '00000002-0000-0000-76c2-f7ad90b5d101',
                  'location' => 'East US 2',
                  'tags' => {},
                  'properties' =>
                      {
                          'encryption_state' => 'Enabled'
                      },
                  'resource_group' => 'resource_group'
              },
              {
                  'id' => '/subscriptions/########-####-####-####-############/resourceGroups/resource_group/providers/Microsoft.DataLakeStore/accounts/name',
                  'name' => 'name',
                  'type' => 'Microsoft.DataLakeStore/accounts',
                  'etag' => '00000002-0000-0000-76c2-f7ad90b5d102',
                  'location' => 'East US 2',
                  'tags' => {},
                  'properties' =>
                      {
                          'encryption_state' => 'Enabled'
                      },
                  'resource_group' => 'resource_group'
              }
          ]
        end
      end
    end
  end
end
