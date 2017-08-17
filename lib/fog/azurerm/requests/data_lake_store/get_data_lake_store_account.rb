module Fog
  module DataLakeStore
    class AzureRM
      # Real class for Data Lake Store Account Request
      class Real
        def get_data_lake_store_account(resource_group, name)
          msg = "Getting Data Lake Store Account #{name} from Resource Group #{resource_group}."
          Fog::Logger.debug msg
          begin
            account = @data_lake_store_account_client.account.get(resource_group, name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          account
        end
      end

      # Mock class for Data Lake Store Account Request
      class Mock
        def get_data_lake_store_account(*)
          {
              'id' => '/subscriptions/########-####-####-####-############/resourceGroups/resource_group/providers/Microsoft.DataLakeStore/accounts/name',
              'name' => 'name',
              'type' => 'Microsoft.DataLakeStore/accounts',
              'etag' => '00000002-0000-0000-76c2-f7ad90b5d101',
              'location' => 'East US 2',
              'tags' => {},
              'encryption_state' => 'Enabled',
              'resource_group' => 'resource_group'
          }
        end
      end
    end
  end
end
