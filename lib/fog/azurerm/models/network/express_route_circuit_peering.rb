module Fog
  module Network
    class AzureRM
      # Express Route Circuit model class for Network Service
      class ExpressRouteCircuitPeering < Fog::Model
        identity :name
        attribute :id
        attribute :resource_group
        attribute :etag
        attribute :circuit_name
        attribute :provisioning_state
        attribute :peering_type
        attribute :shared_key
        attribute :azure_asn
        attribute :peer_asn
        attribute :primary_peer_address_prefix
        attribute :secondary_peer_address_prefix
        attribute :primary_azure_port
        attribute :secondary_azure_port
        attribute :state
        attribute :vlan_id
        attribute :advertised_public_prefixes
        attribute :advertised_public_prefix_state
        attribute :customer_asn
        attribute :routing_registry_name

        def self.parse(circuit_peering)
          hash = {}
          hash['id'] = circuit_peering.id
          hash['name'] = circuit_peering.name
          hash['resource_group'] = get_resource_group_from_id(circuit_peering.id)
          hash['circuit_name'] = circuit_peering.id.split('/')[8]
          hash['provisioning_state'] = circuit_peering.provisioning_state
          hash['peering_type'] = circuit_peering.peering_type
          hash['peer_asn'] = circuit_peering.peer_asn
          hash['azure_asn'] = circuit_peering.azure_asn
          hash['primary_azure_port'] = circuit_peering.primary_azure_port
          hash['secondary_azure_port'] = circuit_peering.secondary_azure_port
          hash['state'] = circuit_peering.state
          hash['primary_peer_address_prefix'] = circuit_peering.primary_peer_address_prefix
          hash['secondary_peer_address_prefix'] = circuit_peering.secondary_peer_address_prefix
          hash['vlan_id'] = circuit_peering.vlan_id

          microsoft_peering_config = circuit_peering.microsoft_peering_config
          unless microsoft_peering_config.nil?
            public_prefixes = microsoft_peering_config.advertised_public_prefixes
            hash['advertised_public_prefixes'] = []
            public_prefixes.each do |public_prefix|
              hash['advertised_public_prefixes'] << public_prefix
            end unless public_prefixes.nil?

            hash['advertised_public_prefix_state'] = microsoft_peering_config.advertised_public_prefixes_state
            hash['customer_asn'] = microsoft_peering_config.customer_asn
            hash['routing_registry_name'] = microsoft_peering_config.routing_registry_name
          end
          hash
        end

        def save
          requires :name, :resource_group, :circuit_name, :peering_type, :peer_asn, :primary_peer_address_prefix, :secondary_peer_address_prefix, :vlan_id
          requires :advertised_public_prefixes if peering_type.casecmp(MICROSOFT_PEERING) == 0
          circuit_peering_parameters = express_route_circuit_peering_params
          circuit_peering = service.create_or_update_express_route_circuit_peering(circuit_peering_parameters)
          merge_attributes(Fog::Network::AzureRM::ExpressRouteCircuitPeering.parse(circuit_peering))
        end

        def destroy
          service.delete_express_route_circuit_peering(resource_group, name, circuit_name)
        end

        private

        def express_route_circuit_peering_params
          circuit_peering_parameters = {
            resource_group_name: resource_group,
            peering_name: name,
            circuit_name: circuit_name,
            peering_type: peering_type,
            peer_asn: peer_asn,
            primary_peer_address_prefix: primary_peer_address_prefix,
            secondary_peer_address_prefix: secondary_peer_address_prefix,
            vlan_id: vlan_id,
            advertised_public_prefixes: advertised_public_prefixes,
            advertised_public_prefix_state: advertised_public_prefix_state,
            customer_asn: customer_asn,
            routing_registry_name: routing_registry_name
          }
          circuit_peering_parameters
        end
      end
    end
  end
end
