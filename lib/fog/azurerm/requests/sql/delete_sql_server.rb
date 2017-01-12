module Fog
  module Sql
    class AzureRM
      # Real class for Sql Server Request
      class Real
        def delete_sql_server(resource_group, name)
          msg = "Deleting SQL Server: #{name}."
          Fog::Logger.debug msg

          begin
            @sql_mgmt_client.servers.delete(resource_group, name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "SQL Server: #{name} deleted successfully."
          true
        end
      end

      # Mock class for Sql Server Request
      class Mock
        def delete_sql_server(*)
          Fog::Logger.debug 'SQL Server {name} from Resource group {resource_group} deleted successfully.'
          true
        end
      end
    end
  end
end
