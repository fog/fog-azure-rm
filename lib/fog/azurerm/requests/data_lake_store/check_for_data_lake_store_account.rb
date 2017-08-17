module Fog
  module DataLakeStore
    class AzureRM
      # Real class for Data Lake Store Account
      class Real
        def check_for_data_lake_store_account(resource_group, name)
          msg = "Getting Data Lake Store Account #{name} from Resource Group #{resource_group}."
          Fog::Logger.debug msg
          begin
            account = @data_lake_store_account_client.account.get(resource_group, name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          !account.nil?
        end
      end

      # Mock class for Data Lake Store Account
      class Mock
        def check_for_data_lake_store_account(*)
          Fog::Logger.debug 'Data Lake Store Account name is available.'
          true
        end
      end
    end
  end
end
