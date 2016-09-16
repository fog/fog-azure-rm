module Fog
  module Network
    class AzureRM
      # Security Rule model for Network Service
      class NetworkSecurityRule < Fog::Model
        identity :name
        attribute :id
        attribute :resource_group
        attribute :network_security_group_name
        attribute :description
        attribute :protocol
        attribute :source_port_range
        attribute :destination_port_range
        attribute :source_address_prefix
        attribute :destination_address_prefix
        attribute :access
        attribute :priority
        attribute :direction

        def self.parse(nsr)
          hash = {}
          hash['id'] = nsr.id
          hash['name'] = nsr.name
          hash['resource_group'] = get_resource_from_resource_id(nsr.id, RESOURCE_GROUP_NAME)
          hash['network_security_group_name'] = get_resource_from_resource_id(nsr.id, RESOURCE_NAME)
          hash['description'] = nsr.description
          hash['protocol'] = nsr.protocol
          hash['source_port_range'] = nsr.source_port_range
          hash['destination_port_range'] = nsr.destination_port_range
          hash['source_address_prefix'] = nsr.source_address_prefix
          hash['destination_address_prefix'] = nsr.destination_address_prefix
          hash['access'] = nsr.access
          hash['priority'] = nsr.priority
          hash['direction'] = nsr.direction
          hash
        end

        def save
          requires :name, :network_security_group_name, :resource_group, :protocol, :source_port_range, :destination_port_range, :source_address_prefix, :destination_address_prefix, :access, :priority, :direction
          security_rule_params = get_security_rule_params
          nsr = service.create_or_update_network_security_rule(security_rule_params)
          merge_attributes(Fog::Network::AzureRM::NetworkSecurityRule.parse(nsr))
        end

        def get_security_rule_params
          {
            name: name,
            resource_group: resource_group,
            protocol: protocol,
            network_security_group_name: network_security_group_name,
            source_port_range: source_port_range,
            destination_port_range: destination_port_range,
            source_address_prefix: source_address_prefix,
            destination_address_prefix: destination_address_prefix,
            access: access,
            priority: priority,
            direction: direction
          }
        end

        def destroy
          service.delete_network_security_rule(resource_group, network_security_group_name, name)
        end
      end
    end
  end
end
