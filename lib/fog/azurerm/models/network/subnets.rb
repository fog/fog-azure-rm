require 'fog/core/collection'
require 'fog/azurerm/models/network/subnet'

module Fog
  module Network
    class AzureRM
      # Subnet collection for network service
      class Subnets < Fog::Collection
        model Fog::Network::AzureRM::Subnet
        attribute :resource_group
        attribute :virtual_network_name

        def all
          requires :resource_group
          requires :virtual_network_name
          subnets = []
          service.list_subnets(resource_group, virtual_network_name).each do |subnet|
            subnets << Fog::Network::AzureRM::Subnet.parse(subnet)
          end
          load(subnets)
        end

        def get(resource_group, virtual_network_name, subnet_name)
          subnet = service.get_subnet(resource_group, virtual_network_name, subnet_name)
          subnet_object = Fog::Network::AzureRM::Subnet.new(service: service)
          subnet_object.merge_attributes(Fog::Network::AzureRM::Subnet.parse(subnet))
        end
      end
    end
  end
end
