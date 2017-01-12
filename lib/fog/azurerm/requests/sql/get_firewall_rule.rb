module Fog
  module Sql
    class AzureRM
      # Real class for Sql Server Firewall Rule Request
      class Real
        def get_firewall_rule(resource_group, server_name, rule_name)
          msg = "Getting Sql Server Firewall Rule: #{rule_name} from SQL Server: #{server_name} in Resource Group: #{resource_group}..."
          Fog::Logger.debug msg

          begin
            firewall_rule = @sql_mgmt_client.servers.get_firewall_rule(resource_group, server_name, rule_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Sql Server Firewall Rule fetched successfully from Server: #{server_name}, Resource Group: #{resource_group}"
          firewall_rule
        end
      end

      # Mock class for Sql Server Firewall Rule Request
      class Mock
        def get_firewall_rule(*)
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
        end
      end
    end
  end
end
