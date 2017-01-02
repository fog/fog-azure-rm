module Fog
  module Sql
    class AzureRM
      # Real class for Sql Server Request
      class Real
        def get_sql_server(resource_group, server_name)
          msg = "Getting Sql Server: #{server_name} in Resource Group: #{resource_group}..."
          Fog::Logger.debug msg
          begin
            sql_server = @sql_mgmt_client.servers.get_by_resource_group(resource_group, server_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Sql Server fetched successfully in Resource Group: #{resource_group}"
          sql_server
        end
      end

      # Mock class for Sql Server Request
      class Mock
        def get_sql_server(*)
          {
            'location' => '{server-location}',
            'properties' => {
              'version' => '{server-version}',
              'administratorLogin' => '{admin-name}',
              'administratorLoginPassword' => '{admin-password}'
            }
          }
        end
      end
    end
  end
end
