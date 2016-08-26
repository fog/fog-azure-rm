module ApiStub
  module Models
    module Network
      class VirtualNetworkGateway
        def self.create_virtual_network_gateway_response(network_client)
          network_gateway = '{
            "name": "myvirtualgateway1",
            "id": "/subscriptions/{subscription-id}/resourceGroups/fog-rg/providers/microsoft.network/virtualNetworkGateways/{virtual-network-gateway-name}",
            "location": "West US",
            "tags": { "key1": "value1" },
            "properties": {
              "gatewayType": "DynamicRouting",
              "gatewaySize": "Default",
              "enableBgp": true,
              "vpnClientAddressPool": [ "{vpnClientAddressPoolPrefix}" ],
              "defaultSites": [ "mysite1" ],
              "gateway_default_site": "/subscriptions/{subscription-id}/resourceGroups/fog-rg/providers/microsoft.network/localNetworkGateways/{local-network-gateway-name}"
            }
          }'
          gateway_mapper = Azure::ARM::Network::Models::VirtualNetworkGateway.mapper
          network_client.deserialize(gateway_mapper, JSON.load(network_gateway), 'result.body')
        end
      end
    end
  end
end
