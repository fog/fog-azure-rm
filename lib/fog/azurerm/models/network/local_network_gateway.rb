module Fog
  module Network
    class AzureRM
      # LocalNetworkGateway model class for Network Service
      class LocalNetworkGateway < Fog::Model
        identity :name
        attribute :id
        attribute :location
        attribute :type
        attribute :resource_group
        attribute :tags
        attribute :local_network_address_space_prefixes
        attribute :gateway_ip_address
        attribute :asn
        attribute :bgp_peering_address
        attribute :peer_weight
        attribute :provisioning_state

        def self.parse(local_network_gateway)
          hash = {}
          hash['id'] = local_network_gateway.id
          hash['name'] = local_network_gateway.name
          hash['location'] = local_network_gateway.location
          hash['type'] = local_network_gateway.type
          hash['resource_group'] = get_resource_group_from_id(local_network_gateway.id)
          hash['tags'] = local_network_gateway.tags
          local_network_address_space = local_network_gateway.local_network_address_space
          unless local_network_address_space.nil?
            hash['local_network_address_space_prefixes'] = local_network_address_space.address_prefixes
          end
          hash['gateway_ip_address'] = local_network_gateway.gateway_ip_address
          bgp_settings = local_network_gateway.bgp_settings
          unless bgp_settings.nil?
            hash['asn'] = bgp_settings.asn
            hash['bgp_peering_address'] = bgp_settings.bgp_peering_address
            hash['peer_weight'] = bgp_settings.peer_weight
          end
          hash['provisioning_state'] = local_network_gateway.provisioning_state
          hash
        end

        def save
          requires :name, :location, :resource_group, :local_network_address_space_prefixes, :gateway_ip_address, :asn, :bgp_peering_address, :peer_weight
          local_network_gateway_params = local_network_gateway_parameters
          local_network_gateway = service.create_or_update_local_network_gateway(local_network_gateway_params)
          merge_attributes(Fog::Network::AzureRM::LocalNetworkGateway.parse(local_network_gateway))
        end

        def destroy
          service.delete_local_network_gateway(resource_group, name)
        end

        private

        def local_network_gateway_parameters
          {
            name: name,
            location: location,
            resource_group: resource_group,
            local_network_address_space_prefixes: local_network_address_space_prefixes,
            gateway_ip_address: gateway_ip_address,
            asn: asn,
            bgp_peering_address: bgp_peering_address,
            peer_weight: peer_weight
          }
        end
      end
    end
  end
end
