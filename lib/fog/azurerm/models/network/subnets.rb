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

        def get(identity)
          all.find { |f| f.name == identity }
        end
      end
    end
  end
end
