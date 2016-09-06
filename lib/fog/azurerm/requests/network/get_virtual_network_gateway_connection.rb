module Fog
  module Network
    class AzureRM
      # Real class for Virtual Network Gateway Connection Request
      class Real
        def get_virtual_network_gateway_connection(resource_group_name, gateway_connection_name)
          msg = "Getting Virtual Network Gateway Connection #{gateway_connection_name} from Resource Group #{resource_group_name}."
          Fog::Logger.debug msg
          begin
            gateway_connection = @network_client.virtual_network_gateway_connections.get(resource_group_name, gateway_connection_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Virtual Network Gateway Connection #{gateway_connection_name} retrieved successfully."
          gateway_connection
        end
      end

      # Mock class for Network Gateway Connection Request
      class Mock
        def get_virtual_network_gateway_connection(*)
          connection = {
            'name' => 'cn1',
            'id' => '/subscriptions/{subscription-id}/resourceGroups/myrg1/providers/microsoft.network/connections/connection1',
            'location' => 'West US',
            'tags' => { 'key1' => 'value1' },
            'properties' => {
              'gateway1' => {
                'name' => 'firstgateway',
                'id' => '/subscriptions/{subscription-id}/resourceGroups/myrg1/providers/microsoft.network/SiteToSite/firstgateway'
              },
              'gateway2' => {
                'name' => 'secondgateway',
                'id' => '/subscriptions/{subscription-id}/resourceGroups/myrg1/providers/microsoft.network/SiteToSite/secondgateway'
              },
              'connectionType' => 'SiteToSite',
              'connectivityState' => 'Connected'
            }
          }
          connection_mapper = Azure::ARM::Network::Models::VirtualNetworkGatewayConnection.mapper
          @network_client.deserialize(connection_mapper, connection, 'result.body')
        end
      end
    end
  end
end
