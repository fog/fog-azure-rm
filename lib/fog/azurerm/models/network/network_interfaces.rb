require 'fog/core/collection'
require 'fog/azurerm/models/network/network_interface'

module Fog
  module Network
    class AzureRM
      # NetworkInterfaces collection class for Network Service
      class NetworkInterfaces < Fog::Collection
        model Fog::Network::AzureRM::NetworkInterface
        attribute :resource_group

        def all
          requires :resource_group
          network_interfaces = []
          service.list_network_interfaces(resource_group).each do |nic|
            network_interfaces << Fog::Network::AzureRM::NetworkInterface.parse(nic)
          end
          load(network_interfaces)
        end

        def get(resource_group, name)
          nic = service.get_network_interface(resource_group, name)
          network_interface = Fog::Network::AzureRM::NetworkInterface.new(service: service)
          network_interface.merge_attributes(Fog::Network::AzureRM::NetworkInterface.parse(nic))
        end
      end
    end
  end
end
