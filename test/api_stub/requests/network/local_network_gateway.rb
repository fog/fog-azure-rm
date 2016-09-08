module ApiStub
  module Requests
    module Network
      # Mock class for Local Network Gateway Requests
      class LocalNetworkGateway
        def self.create_local_network_gateway_response(network_client)
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
                },
                'gateway_ip_address' => '192.168.1.1'
              }
          }
          local_network_gateway_mapper = Azure::ARM::Network::Models::LocalNetworkGateway.mapper
          network_client.deserialize(local_network_gateway_mapper, local_network_gateway, 'result.body')
        end

        def self.delete_local_network_gateway_response
          MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
        end

        def self.list_local_network_gateway_response(network_client)
          local_network_gateway =  {
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
          local_network_gateway_mapper = Azure::ARM::Network::Models::LocalNetworkGatewayListResult.mapper
          network_client.deserialize(local_network_gateway_mapper, local_network_gateway, 'result.body')
        end
      end
    end
  end
end
