
module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def create_or_update_virtual_network_gateway_connection(gateway_connection_params)
          msg = "Creating/Updating Virtual Network Gateway Connection: #{gateway_connection_params[:name]} in Resource Group: #{gateway_connection_params[:resource_group_name]}."
          Fog::Logger.debug msg
          gateway_connection = get_network_gateway_object(gateway_connection_params)
          begin
            network_gateway_connection = @network_client.virtual_network_gateway_connections.create_or_update(gateway_connection_params[:resource_group_name], gateway_connection_params[:name], gateway_connection)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Virtual Network Gateway Connection #{gateway_connection_params[:name]} created/updated successfully."
          network_gateway_connection
        end

        private

        def get_network_gateway_object(gateway_connection_params)
          gateway_connection = Azure::ARM::Network::Models::VirtualNetworkGatewayConnection.new

          gateway_connection.name = gateway_connection_params[:name]
          gateway_connection.location = gateway_connection_params[:location]
          gateway_connection.tags = gateway_connection_params[:tags] if gateway_connection.tags.nil?

          if gateway_connection_params[:virtual_network_gateway1]
            gateway_connection.virtual_network_gateway1 = get_network_gateway_object(gateway_connection_params[:virtual_network_gateway1])
          end

          if gateway_connection_params[:virtual_network_gateway2]
            gateway_connection.virtual_network_gateway2 = get_network_gateway_object(gateway_connection_params[:virtual_network_gateway2])
          end

          gateway_connection.authorization_key = gateway_connection_params[:authorization_key]
          gateway_connection.connection_type = gateway_connection_params[:connection_type]
          gateway_connection.routing_weight = gateway_connection_params[:routing_weight]
          gateway_connection.shared_key = gateway_connection_params[:shared_key]
          gateway_connection.connection_status = gateway_connection_params[:connection_status]
          gateway_connection.egress_bytes_transferred = gateway_connection_params[:egress_bytes_transferred]
          gateway_connection.ingress_bytes_transferred = gateway_connection_params[:ingress_bytes_transferred]
          gateway_connection.peer = gateway_connection_params[:peer]
          gateway_connection.resource_guid = gateway_connection_params[:resource_guid]
          gateway_connection.enable_bgp = gateway_connection_params[:enable_bgp]
          gateway_connection.provisioning_state = gateway_connection_params[:provisioning_state]

          gateway_connection
        end
      end

      # Mock class for Network Request
      class Mock
        def create_or_update_virtual_network_gateway_connection(*)
          connection = {
            'name' => 'cn1',
            'location' => 'West US',
            'tags' => { 'key1' => 'value1' },
            'properties' => {
              'gateway1' => {
                'name' => 'firstgateway'
              },
              'gateway2' => {
                'name' => 'secondgateway'
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
