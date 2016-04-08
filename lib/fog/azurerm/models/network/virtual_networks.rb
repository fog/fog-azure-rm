require 'fog/core/collection'
require 'fog/azurerm/models/network/virtual_network'
require 'fog/azurerm/models/network/subnets'

module Fog
  module Network
    class AzureRM
      class VirtualNetworks < Fog::Collection
        model Fog::Network::AzureRM::VirtualNetwork

        def all
          virtual_networks = []
          service.list_virtual_networks.each do |vnet|
            hash = {}
            hash['id'] = vnet['id']
            hash['name'] = vnet['name']
            hash['location'] = vnet['location']
            hash['resource_group'] = vnet['id'].split('/')[4]
            hash['addressPrefixes'] = vnet['properties']['addressSpace']['addressPrefixes'] unless vnet['properties']['addressSpace'].nil?
            hash['dnsServers'] = vnet['properties']['dhcpOptions']['dnsServers'] unless vnet['properties']['dhcpOptions'].nil?
            hash['subnets'] = Fog::Network::AzureRM::Subnets.deserialize_subnets_list(vnet['properties']['subnets'])
            virtual_networks << hash
          end
          load(virtual_networks)
        end

        def get(identity, resource_group)
          all.find { |f| f.name == identity && f.resource_group == resource_group }
        rescue Fog::Errors::NotFound
          nil
        end

        def check_name_availability(name, resource_group)
          puts "Checkng if Virtual Network #{name} exists."
          if service.check_for_virtual_network(name, resource_group)
            puts "Virtual Network #{name} exists."
          else
            puts "Virtual Network #{name} doesn't exists."
          end
        end
      end
    end
  end
end
