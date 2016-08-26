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
      end
    end
  end
end
