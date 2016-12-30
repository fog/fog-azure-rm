module Fog
  module Network
    class AzureRM
      # This class is giving implementation of all/list, get and
      # check name availability for virtual network.
      class VirtualNetworks < Fog::Collection
        model Fog::Network::AzureRM::VirtualNetwork
        attribute :resource_group

        def all
          requires :resource_group
          virtual_networks = []
          service.list_virtual_networks(resource_group).each do |vnet|
            virtual_networks << Fog::Network::AzureRM::VirtualNetwork.parse(vnet)
          end
          load(virtual_networks)
        end

        def get(resource_group_name, virtual_network_name)
          virtual_network = service.get_virtual_network(resource_group_name, virtual_network_name)
          virtual_network_fog = Fog::Network::AzureRM::VirtualNetwork.new(service: service)
          virtual_network_fog.merge_attributes(Fog::Network::AzureRM::VirtualNetwork.parse(virtual_network))
        end

        def check_virtual_network_exists?(resource_group, name)
          service.check_virtual_network_exists?(resource_group, name)
        end
      end
    end
  end
end
