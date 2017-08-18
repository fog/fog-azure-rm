module Fog
  module DataLakeStore
    class AzureRM
      # Real class for Data Lake Store Account Request
      class Real
        def delete_data_lake_store_account(resource_group, name)
          msg = "Deleting Data Lake Store Account #{name} from Resource Group #{resource_group}."
          Fog::Logger.debug msg
          begin
            @data_lake_store_account_client.account.delete(resource_group, name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Data Lake Store Account #{name} Deleted Successfully."
          true
        end
      end

      # Mock class for Data Lake Store Account Request
      class Mock
        def delete_data_lake_store_account(*)
          Fog::Logger.debug 'Data Lake Store Account deleted successfully.'
          true
        end
      end
    end
  end
end
