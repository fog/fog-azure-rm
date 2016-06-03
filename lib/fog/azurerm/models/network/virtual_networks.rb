require 'fog/core/collection'
require 'fog/azurerm/models/network/virtual_network'

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

        def get(identity)
          all.find { |f| f.name == identity }
        end

        def check_if_exists(resource_group, name)
          Fog::Logger.debug "Checkng if Virtual Network #{name} exists."
          if service.check_for_virtual_network(name, resource_group)
            Fog::Logger.debug "Virtual Network #{name} exists."
            true
          else
            Fog::Logger.debug "Virtual Network #{name} doesn't exists."
            false
          end
        end
      end
    end
  end
end
