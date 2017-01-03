module Fog
  module Sql
    class AzureRM
      # Real class for Firewall Rule Request
      class Real
        def create_or_update_firewall_rule(firewall_hash)
          msg = "Creating SQL Firewall Rule : #{firewall_hash[:name]}."
          Fog::Logger.debug msg

          begin
            server_firewall_rule = @sql_mgmt_client.servers.create_or_update_firewall_rule(firewall_hash[:resource_group], firewall_hash[:server_name], firewall_hash[:name], format_server_firewall_parameters(firewall_hash[:start_ip], firewall_hash[:end_ip]))
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "SQL Firewall Rule : #{firewall_hash[:name]} created successfully."
          server_firewall_rule
        end

        private

        def format_server_firewall_parameters(start_ip, end_ip)
          firewall_rule = Azure::ARM::SQL::Models::ServerFirewallRule.new
          firewall_rule.start_ip_address = start_ip
          firewall_rule.end_ip_address = end_ip
          firewall_rule
        end
      end

      # Mock class for Sql Firewall Rule Request
      class Mock
        def create_or_update_firewall_rule(*)
          {
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
