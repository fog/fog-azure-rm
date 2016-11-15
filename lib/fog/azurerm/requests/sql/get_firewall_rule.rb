module Fog
  module Sql
    class AzureRM
      # Real class for Sql Server Firewall Rule Request
      class Real
        def get_firewall_rule(resource_group, server_name, rule_name)
          msg = "Getting Sql Server Firewall Rule: #{rule_name} from SQL Server: #{server_name} in Resource Group: #{resource_group}..."
          Fog::Logger.debug msg
          resource_url = "#{resource_manager_endpoint_url}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.Sql/servers/#{server_name}/firewallRules/#{rule_name}?api-version=2014-04-01-preview"
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            response = RestClient.get(
              resource_url,
              accept: :json,
              content_type: :json,
              authorization: token
            )
          rescue RestClient::Exception => e
            raise ::JSON.parse(e.response)['message']
          end
          Fog::Logger.debug "Sql Server Firewall Rule fetched successfully from Server: #{server_name}, Resource Group: #{resource_group}"
          ::JSON.parse(response)
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
