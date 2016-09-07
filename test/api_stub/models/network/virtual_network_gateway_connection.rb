module ApiStub
  module Models
    module Network
      class VirtualNetworkGatewayConnection
        def self.create_virtual_network_gateway_connection_response(network_client)
          gateway_connection = '{
            "name": "cn1",
            "id": "/subscriptions/{subscription-id}/resourceGroups/{resource_group_name}/providers/microsoft.network/connections/connection1",
            "location": "West US",
            "tags": { "key1": "value1" },
            "properties": {
              "virtualNetworkGateway1": {
                "name": "firstgateway",
                "id": "/subscriptions/{subscription-id}/resourceGroups/{resource_group_name}/providers/microsoft.network/SiteToSite/firstgateway"
              },
              "virtualNetworkGateway2": {
                "name": "secondgateway",
                "id": "/subscriptions/{subscription-id}/resourceGroups/{resource_group_name}/providers/microsoft.network/SiteToSite/secondgateway"
              },
              "connectionType": "SiteToSite",
              "connectivityState": "Connected"
            }
          }'
          connection_mapper = Azure::ARM::Network::Models::VirtualNetworkGatewayConnection.mapper
          network_client.deserialize(connection_mapper, JSON.load(gateway_connection), 'result.body')
        end
      end
    end
  end
end
