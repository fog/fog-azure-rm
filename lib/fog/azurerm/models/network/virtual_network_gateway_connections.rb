require 'fog/core/collection'
require 'fog/azurerm/models/network/virtual_network_gateway_connection'

module Fog
  module Network
    class AzureRM
      # VirtualNetworkGatewayConnections collection class for Network Service
      class VirtualNetworkGatewayConnections < Fog::Collection
        model VirtualNetworkGatewayConnection
        attribute :resource_group

        def all
          requires :resource_group
          gateway_connections = service.list_virtual_network_gateway_connections(resource_group).map { |connection| VirtualNetworkGatewayConnection.parse(connection) }
          load(gateway_connections)
        end

        def get(resource_group_name, name)
          connection = service.get_virtual_network_gateway_connection(resource_group_name, name)
          gateway_connection = VirtualNetworkGatewayConnection.new(service: service)
          gateway_connection.merge_attributes(VirtualNetworkGatewayConnection.parse(connection))
        end
      end
    end
  end
end
