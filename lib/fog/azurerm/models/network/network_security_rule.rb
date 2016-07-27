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
          hash['id'] = nsr['id']
          hash['name'] = nsr['name']
          hash['resource_group'] = nsr['id'].split('/')[4]
          hash['network_security_group_name'] = nsr['id'].split('/')[8]
          hash['description'] = nsr['properties']['description']
          hash['protocol'] = nsr['properties']['protocol']
          hash['source_port_range'] = nsr['properties']['sourcePortRange']
          hash['destination_port_range'] = nsr['properties']['destinationPortRange']
          hash['source_address_prefix'] = nsr['properties']['sourceAddressPrefix']
          hash['destination_address_prefix'] = nsr['properties']['destinationAddressPrefix']
          hash['access'] = nsr['properties']['access']
          hash['priority'] = nsr['properties']['priority']
          hash['direction'] = nsr['properties']['direction']
          hash
        end
      end
    end
  end
end
