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
            hash = {}
            subnet.instance_variables.each do |var|
              hash[var.to_s.delete('@')] = subnet.instance_variable_get(var)
            end
            hash['resource_group'] = subnet.instance_variable_get('@id').split('/')[4]
            hash['virtual_network_name'] = subnet.instance_variable_get('@id').split('/')[8]
            subnets << hash
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
