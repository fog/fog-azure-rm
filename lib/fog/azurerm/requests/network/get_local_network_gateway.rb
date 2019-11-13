module Fog
  module Network
    class AzureRM
      # Real class for Local Network Gateway Request
      class Real
        def get_local_network_gateway(resource_group_name, local_network_gateway_name)
          msg = @logger_messages['network']['local_network_gateway']['message']['get']
                .gsub('NAME', local_network_gateway_name).gsub('RESOURCE_GROUP', resource_group_name)
          Fog::Logger.debug msg
          begin
            local_network_gateway = @network_client.local_network_gateways.get(resource_group_name, local_network_gateway_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Local Network Gateway #{local_network_gateway_name} retrieved successfully."
          local_network_gateway
        end
      end

      # Mock class for Local Network Gateway Request
      class Mock
        def get_local_network_gateway(*)
          local_network_gateway = {
            'id' => '/subscriptions/<Subscription_id>/resourceGroups/learn_fog/providers/Microsoft.Network/localNetworkGateways/testLocalNetworkGateway',
            'name' => 'testLocalNetworkGateway',
            'type' => 'Microsoft.Network/localNetworkGateways',
            'location' => 'eastus',
            'properties' =>
              {
                'local_network_address_space' => {
                  'address_prefixes' => []
                },
                'gateway_ip_address' => '192.168.1.1',
                'bgp_settings' => {
                  'asn' => 100,
                  'bgp_peering_address' => '192.168.1.2',
                  'peer_weight' => 3
                }
              }
          }
          local_network_gateway_mapper = Azure::Network::Profiles::Latest::Mgmt::Models::LocalNetworkGateway.mapper
          @network_client.deserialize(local_network_gateway_mapper, local_network_gateway, 'result.body')
        end
      end
    end
  end
end
