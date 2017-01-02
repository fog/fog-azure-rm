module Fog
  module Sql
    class AzureRM
      # Real class for Sql Server Firewall Rule Request
      class Real
        def list_firewall_rules(resource_group, server_name)
          msg = "Listing Sql Server Firewall rules on server: #{server_name} in Resource Group: #{resource_group}."
          Fog::Logger.debug msg

          begin
            firewall_rules = @sql_mgmt_client.servers.list_firewall_rules(resource_group, server_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Sql Server Firewall Rules listed successfully on server: #{server_name} in Resource Group: #{resource_group}"
          firewall_rules
        end
      end

      # Mock class for Sql Server Firewall Rule Request
      class Mock
        def list_firewall_rules(*)
          [
            {
              'id' => '{uri-of-firewall-rule}',
              'name' => '{rule-name}',
              'type' => '{rule-type}',
              'location' => '{server-location}',
              'properties' => {
                'startIpAddress' => '{start-ip-address}',
                'endIpAddress' => '{end-ip-address}'
              }
            },
            {
              'id' => '{uri-of-firewall-rule}',
              'name' => '{rule-name}',
              'type' => '{rule-type}',
              'location' => '{server-location}',
              'properties' => {
                'startIpAddress' => '{start-ip-address}',
                'endIpAddress' => '{end-ip-address}'
              }
            }
          ]
        end
      end
    end
  end
end
