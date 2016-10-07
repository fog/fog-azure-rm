module Fog
  module Network
    class AzureRM
      # VirtualNetworkGateways collection class for Network Service
      class VirtualNetworkGateways < Fog::Collection
        model VirtualNetworkGateway
        attribute :resource_group

        def all
          requires :resource_group
          network_gateways = []
          service.list_virtual_network_gateways(resource_group).each do |gateway|
            network_gateways << VirtualNetworkGateway.parse(gateway)
          end
          load(network_gateways)
        end

        def get(resource_group_name, name)
          network_gateway = service.get_virtual_network_gateway(resource_group_name, name)
          virtual_network_gateway = VirtualNetworkGateway.new(service: service)
          virtual_network_gateway.merge_attributes(VirtualNetworkGateway.parse(network_gateway))
        end
      end
    end
  end
end
