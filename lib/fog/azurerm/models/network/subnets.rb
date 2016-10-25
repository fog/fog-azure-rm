module Fog
  module Network
    class AzureRM
      # Subnet collection for network service
      class Subnets < Fog::Collection
        model Subnet
        attribute :resource_group
        attribute :virtual_network_name

        def all
          requires :resource_group, :virtual_network_name
          subnets = []
          service.list_subnets(resource_group, virtual_network_name).each do |subnet|
            subnets << Subnet.parse(subnet)
          end
          load(subnets)
        end

        def get(resource_group, virtual_network_name, subnet_name)
          subnet = service.get_subnet(resource_group, virtual_network_name, subnet_name)
          subnet_object = Subnet.new(service: service)
          subnet_object.merge_attributes(Subnet.parse(subnet))
        end
      end
    end
  end
end
