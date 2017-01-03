module Fog
  module Sql
    class AzureRM
      # Real class for Sql Firewall Rule Request
      class Real
        def delete_firewall_rule(resource_group, server_name, rule_name)
          msg = "Deleting SQL Firewall Rule: #{rule_name}."
          Fog::Logger.debug msg

          begin
            @sql_mgmt_client.servers.delete_firewall_rule(resource_group, server_name, rule_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "SQL Firewall Rule: #{rule_name} deleted successfully."
          true
        end
      end

      # Mock class for Sql Firewall Rule Request
      class Mock
        def delete_firewall_rule(*)
          Fog::Logger.debug 'SQL Firewall Rule {name} from SQL Server {server_name}, Resource group {resource_group} deleted successfully.'
          true
        end
      end
    end
  end
end
