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
          local_network_gateway_hash = get_hash_from_object(local_network_gateway)
          bgp_settings = local_network_gateway.bgp_settings
          unless bgp_settings.nil?
            local_network_gateway_hash['asn'] = bgp_settings.asn
            local_network_gateway_hash['bgp_peering_address'] = bgp_settings.bgp_peering_address
            local_network_gateway_hash['peer_weight'] = bgp_settings.peer_weight
          end
          local_network_address_space = local_network_gateway.local_network_address_space
          local_network_gateway_hash['local_network_address_space_prefixes'] = local_network_address_space.address_prefixes unless local_network_address_space.nil?
          local_network_gateway_hash['resource_group'] = get_resource_group_from_id(local_network_gateway.id)
          local_network_gateway_hash
        end

        def save
          requires :name, :location, :resource_group, :local_network_address_space_prefixes, :gateway_ip_address, :asn, :bgp_peering_address, :peer_weight
          local_network_gateway = service.create_or_update_local_network_gateway(local_network_gateway_parameters)
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
