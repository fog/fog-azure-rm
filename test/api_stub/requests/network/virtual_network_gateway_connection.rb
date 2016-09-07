module ApiStub
  module Requests
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

        def self.list_virtual_network_gateway_connection_response(network_client)
          gateway_connection = '{
            "value": [
              {
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
              }
            ]
          }'
          connection_mapper = Azure::ARM::Network::Models::VirtualNetworkGatewayConnectionListResult.mapper
          network_client.deserialize(connection_mapper, JSON.load(gateway_connection), 'result.body')
        end

        def self.set_connection_shared_key_response(network_client)
          shared_key = '{
            "value": "hello"
          }'
          shared_key_mapper = Azure::ARM::Network::Models::ConnectionSharedKey.mapper
          network_client.deserialize(shared_key_mapper, JSON.load(shared_key), 'result.body')
        end

        def self.get_connection_shared_key_response(network_client)
          shared_key = '{
            "value": "hello"
          }'
          shared_key_mapper = Azure::ARM::Network::Models::ConnectionSharedKeyResult.mapper
          network_client.deserialize(shared_key_mapper, JSON.load(shared_key), 'result.body')
        end

        def self.reset_connection_shared_key_response(network_client)
          shared_key = '{
            "KeyLength": "20"
          }'
          shared_key_mapper = Azure::ARM::Network::Models::ConnectionResetSharedKey.mapper
          network_client.deserialize(shared_key_mapper, JSON.load(shared_key), 'result.body')
        end

        def self.delete_virtual_network_gateway_connection_response
          MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
        end
      end
    end
  end
end
