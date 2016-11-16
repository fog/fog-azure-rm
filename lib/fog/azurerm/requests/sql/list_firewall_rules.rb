module Fog
  module Sql
    class AzureRM
      # Real class for Sql Server Firewall Rule Request
      class Real
        def list_firewall_rules(resource_group, server_name)
          msg = "Listing Sql Server Firewall rules on server: #{server_name} in Resource Group: #{resource_group}."
          Fog::Logger.debug msg
          resource_url = "#{resource_manager_endpoint_url}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.Sql/servers/#{server_name}/firewallRules/?api-version=2014-04-01-preview"
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            response = RestClient.get(
              resource_url,
              accept: :json,
              content_type: :json,
              authorization: token
            )
          rescue RestClient::Exception => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Sql Server Firewall Rules listed successfully on server: #{server_name} in Resource Group: #{resource_group}"
          Fog::JSON.decode(response)['value']
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
