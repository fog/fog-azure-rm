module Fog
  module Sql
    class AzureRM
      # Real class for Sql Database Request
      class Real
        def delete_database(resource_group, server_name, name)
          msg = "Deleting SQL Database: #{name}."
          Fog::Logger.debug msg
          begin
            @sql_mgmt_client.databases.delete(resource_group, server_name, name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "SQL Database: #{name} deleted successfully."
          true
        end
      end

      # Mock class for Sql Database Request
      class Mock
        def delete_database(*)
          Fog::Logger.debug 'SQL Database {name} from Resource group {resource_group} deleted successfully.'
          true
        end
      end
    end
  end
end
