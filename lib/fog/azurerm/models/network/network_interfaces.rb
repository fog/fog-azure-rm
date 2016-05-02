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
          network_interface_list = service.list_network_interfaces(resource_group)
          network_interface_list.each do |nic|
            hash = {}
            nic.instance_variables.each do |var|
              hash[var.to_s.delete('@')] = nic.instance_variable_get(var)
            end
            hash['resource_group'] = resource_group
            network_interfaces << hash
          end
          load(network_interfaces)
        end

        def get(identity)
          all.find { |f| f.name == identity }
        end
      end
    end
  end
end
