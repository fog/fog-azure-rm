module Fog
  module Network
    class AzureRM
      # Real class for Local Network Gateway Request
      class Real
        def list_local_network_gateways(resource_group_name)
          msg = @logger_messages['network']['local_network_gateway']['message']['list']
                .gsub('RESOURCE_GROUP', resource_group_name)
          Fog::Logger.debug msg
          begin
            local_network_gateways = @network_client.local_network_gateways.list_as_lazy(resource_group_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          local_network_gateways.value
        end
      end

      # Mock class for Local Network Gateway Request
      class Mock
        def list_virtual_network_gateways(*)
          local_network_gateway = {
            'value' => [
              {
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
            ]
          }
          local_network_gateway_mapper = Azure::Network::Profiles::Latest::Mgmt::Models::LocalNetworkGatewayListResult.mapper
          @network_client.deserialize(local_network_gateway_mapper, local_network_gateway, 'result.body')
        end
      end
    end
  end
end
