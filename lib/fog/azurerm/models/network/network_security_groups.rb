module Fog
  module Network
    class AzureRM
      # collection class for Network Security Group
      class NetworkSecurityGroups < Fog::Collection
        model NetworkSecurityGroup
        attribute :resource_group

        def all
          requires :resource_group
          network_security_groups = []
          service.list_network_security_groups(resource_group).each do |nsg|
            network_security_groups << NetworkSecurityGroup.parse(nsg)
          end
          load(network_security_groups)
        end

        def get(resource_group, name)
          nsg = service.get_network_security_group(resource_group, name)
          network_security_group = NetworkSecurityGroup.new(service: service)
          network_security_group.merge_attributes(NetworkSecurityGroup.parse(nsg))
        end
      end
    end
  end
end
