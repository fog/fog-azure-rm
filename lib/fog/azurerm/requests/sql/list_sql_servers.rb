module Fog
  module Sql
    class AzureRM
      # Real class for Sql Server Request
      class Real
        def list_sql_servers(resource_group)
          msg = "Listing Sql Servers in Resource Group: #{resource_group}."
          Fog::Logger.debug msg
          begin
            servers = @sql_mgmt_client.servers.list_by_resource_group(resource_group)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Sql Servers listed successfully in Resource Group: #{resource_group}"
          servers
        end
      end

      # Mock class for Sql Server Request
      class Mock
        def list_sql_servers(*)
          [
            {
              'location' => '{server-location}',
              'properties' => {
                'version' => '{server-version}',
                'administratorLogin' => '{admin-name}',
                'administratorLoginPassword' => '{admin-password}'
              }
            },
            {
              'location' => '{server-location}',
              'properties' => {
                'version' => '{server-version}',
                'administratorLogin' => '{admin-name}',
                'administratorLoginPassword' => '{admin-password}'
              }
            }
          ]
        end
      end
    end
  end
end
