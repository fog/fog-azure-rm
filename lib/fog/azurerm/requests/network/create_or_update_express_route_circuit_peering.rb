module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def create_or_update_express_route_circuit_peering(resource_group_name, peering_name, circuit_name, peering_type, peer_asn, primary_peer_address_prefix, secondary_peer_address_prefix, vlan_id, advertised_public_prefixes, advertised_public_prefix_state, customer_asn, routing_registry_name)
          Fog::Logger.debug "Creating/Updating Express Route Circuit Peering: #{peering_name}..."
          circuit_peering = get_express_route_circuit_peering_object(peering_name, peering_type, peer_asn, primary_peer_address_prefix, secondary_peer_address_prefix, vlan_id, advertised_public_prefixes, advertised_public_prefix_state, customer_asn, routing_registry_name)
          begin
            promise = @network_client.express_route_circuit_peerings.create_or_update(resource_group_name, circuit_name, peering_name, circuit_peering)
            result = promise.value!
            Fog::Logger.debug "Express Route Circuit Peering #{peering_name} created/updated successfully."
            Azure::ARM::Network::Models::ExpressRouteCircuitPeering.serialize_object(result.body)
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception creating/updating Express Route Circuit Peering #{peering_name} in Resource Group: #{resource_group_name}. #{e.body['error']['message']}"
            raise msg
          end
        end

        private

        def get_express_route_circuit_peering_object(peering_name, peering_type, peer_asn, primary_peer_address_prefix, secondary_peer_address_prefix, vlan_id, advertised_public_prefixes, advertised_public_prefix_state, customer_asn, routing_registry_name)
          peering_config = Azure::ARM::Network::Models::ExpressRouteCircuitPeeringConfig.new
          peering_config.advertised_public_prefixes = advertised_public_prefixes
          peering_config.advertised_public_prefixes_state = advertised_public_prefix_state
          peering_config.customer_asn = customer_asn
          peering_config.routing_registry_name = routing_registry_name

          circuit_peering_props = Azure::ARM::Network::Models::ExpressRouteCircuitPeeringPropertiesFormat.new
          circuit_peering_props.peering_type = peering_type
          circuit_peering_props.peer_asn = peer_asn
          circuit_peering_props.primary_peer_address_prefix = primary_peer_address_prefix
          circuit_peering_props.secondary_peer_address_prefix = secondary_peer_address_prefix
          circuit_peering_props.vlan_id = vlan_id
          circuit_peering_props.microsoft_peering_config = peering_config

          express_route_circuit_peering = Azure::ARM::Network::Models::ExpressRouteCircuitPeering.new
          express_route_circuit_peering.name = peering_name
          express_route_circuit_peering.properties = circuit_peering_props

          express_route_circuit_peering
        end
      end

      # Mock class for Network Request
      class Mock
        def create_or_update_express_route_circuit_peering(*)
          {
            'name' => 'PeeringName',
            'properties' => {
              'peeringType' => 'MicrosoftPeering',
              'peerASN' => 100,
              'primaryPeerAddressPrefix' => '192.168.1.0/30',
              'secondaryPeerAddressPrefix' => '192.168.2.0/30',
              'vlanId' => 200,
              'microsoftPeeringConfig' => {
                'advertisedpublicprefixes' => [
                  '11.2.3.4/30',
                  '12.2.3.4/30'
                ],
                'advertisedPublicPrefixState' => 'NotConfigured',
                'customerAsn' => 200,
                'routingRegistryName' => '<name>'
              }
            }
          }
        end
      end
    end
  end
end
