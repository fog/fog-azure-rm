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
          express_route_circuit_peering_properties = circuit_peering['properties']
          hash = {}
          hash['id'] = circuit_peering['id']
          hash['name'] = circuit_peering['name']
          hash['resource_group'] = get_resource_group_from_id(circuit_peering['id'])
          hash['circuit_name'] = circuit_peering['id'].split('/')[8]
          hash['provisioning_state'] = express_route_circuit_peering_properties['provisioningState']
          hash['peering_type'] = express_route_circuit_peering_properties['peeringType']
          hash['peer_asn'] = express_route_circuit_peering_properties['peerASN']
          hash['azure_asn'] = express_route_circuit_peering_properties['azureASN']
          hash['primary_azure_port'] = express_route_circuit_peering_properties['primaryAzurePort']
          hash['secondary_azure_port'] = express_route_circuit_peering_properties['secondaryAzurePort']
          hash['state'] = express_route_circuit_peering_properties['state']
          hash['primary_peer_address_prefix'] = express_route_circuit_peering_properties['primaryPeerAddressPrefix']
          hash['secondary_peer_address_prefix'] = express_route_circuit_peering_properties['secondaryPeerAddressPrefix']
          hash['vlan_id'] = express_route_circuit_peering_properties['vlanId']

          unless express_route_circuit_peering_properties['microsoftPeeringConfig'].nil?
            public_prefixes = express_route_circuit_peering_properties['microsoftPeeringConfig']['advertisedpublicprefixes']
            hash['advertised_public_prefixes'] = []
            public_prefixes.each do |public_prefix|
              hash['advertised_public_prefixes'] << public_prefix
            end unless public_prefixes.nil?

            hash['advertised_public_prefix_state'] = express_route_circuit_peering_properties['microsoftPeeringConfig']['advertisedPublicPrefixState']
            hash['customer_asn'] = express_route_circuit_peering_properties['microsoftPeeringConfig']['customerAsn']
            hash['routing_registry_name'] = express_route_circuit_peering_properties['microsoftPeeringConfig']['routingRegistryName']
          end
          hash
        end

        def save
          requires :name, :resource_group, :circuit_name, :peering_type, :peer_asn, :primary_peer_address_prefix, :secondary_peer_address_prefix, :vlan_id
          requires :advertised_public_prefixes if peering_type.casecmp(MICROSOFT_PEERING) == 0
          circuit_peering_parameters = express_route_circuit_peering_params
          circuit_peering = service.create_or_update_express_route_circuit_peering(circuit_peering_parameters)
          merge_attributes(Fog::Network::AzureRM::ExpressRouteCircuit.parse(circuit_peering))
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
