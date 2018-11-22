module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def list_virtual_network_gateway_connections(resource_group_name)
          msg = @logger_messages['network']['virtual_network_gateway_connection']['message']['list']
                .gsub('RESOURCE_GROUP', resource_group_name)
          Fog::Logger.debug msg
          begin
            gateway_connections = @network_client.virtual_network_gateway_connections.list_as_lazy(resource_group_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          gateway_connections.value
        end
      end

      # Mock class for Network Request
      class Mock
        def list_virtual_network_gateway_connections(*)
          connection = {
            'value' => [
              {
                'name' => 'cn1',
                'id' => '/subscriptions/{subscription-id}/resourceGroups/{resource_group_name}/providers/microsoft.network/connections/connection1',
                'location' => 'West US',
                'tags' => { 'key1' => 'value1' },
                'properties' => {
                  'virtualNetworkGateway1' => {
                    'name' => 'firstgateway',
                    'id' => '/subscriptions/{subscription-id}/resourceGroups/{resource_group_name}/providers/microsoft.network/SiteToSite/firstgateway'
                  },
                  'virtualNetworkGateway2' => {
                    'name' => 'secondgateway',
                    'id' => '/subscriptions/{subscription-id}/resourceGroups/{resource_group_name}/providers/microsoft.network/SiteToSite/secondgateway'
                  },
                  'connectionType' => 'SiteToSite',
                  'connectivityState' => 'Connected'
                }
              }
            ]
          }
          connection_mapper = Azure::Network::Profiles::Latest::Mgmt::Models::VirtualNetworkGatewayConnectionListResult.mapper
          @network_client.deserialize(connection_mapper, connection, 'result.body').value
        end
      end
    end
  end
end
