module Fog
  module Network
    class AzureRM
      # NetworkInterfaces collection class for Network Service
      class NetworkInterfaces < Fog::Collection
        model NetworkInterface
        attribute :resource_group

        def all
          requires :resource_group
          network_interfaces = []
          service.list_network_interfaces(resource_group).each do |nic|
            network_interfaces << NetworkInterface.parse(nic)
          end
          load(network_interfaces)
        end

        def get(resource_group_name, name)
          nic = service.get_network_interface(resource_group_name, name)
          network_interface_card = NetworkInterface.new(service: service)
          network_interface_card.merge_attributes(NetworkInterface.parse(nic))
        end
      end
    end
  end
end
