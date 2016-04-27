require 'fog/core/collection'
require 'fog/azurerm/models/network/virtual_network'

module Fog
  module Network
    class AzureRM
      class VirtualNetworks < Fog::Collection
        model Fog::Network::AzureRM::VirtualNetwork

        def all
          virtual_networks = []
          service.list_virtual_networks.each do |vnet|
            hash = {}
            vnet.instance_variables.each do |var|
              hash[var.to_s.delete('@')] = vnet.instance_variable_get(var)
            end
            hash['resource_group'] = vnet.instance_variable_get('@id').split('/')[4]
            virtual_networks << hash
          end
          load(virtual_networks)
        end

        def get(identity, resource_group)
          all.find { |f| f.name == identity && f.resource_group == resource_group }
        rescue Fog::Errors::NotFound
          nil
        end

        def check_if_exists(name, resource_group)
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
