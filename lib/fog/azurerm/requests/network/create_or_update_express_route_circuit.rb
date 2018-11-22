module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def create_or_update_express_route_circuit(circuit_parameters)
          msg = "Creating/updating Express Route Circuit #{circuit_parameters[:circuit_name]} in Resource Group: #{circuit_parameters[:resource_group_name]}."
          Fog::Logger.debug msg
          circuit = get_express_route_circuit_object(circuit_parameters)
          begin
            circuit = @network_client.express_route_circuits.create_or_update(circuit_parameters[:resource_group_name], circuit_parameters[:circuit_name], circuit)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Express Route Circuit #{circuit_parameters[:circuit_name]} created/updated successfully."
          circuit
        end

        private

        def get_express_route_circuit_object(circuit_parameters)
          sku = create_express_route_circuit_sku(circuit_parameters[:sku_name], circuit_parameters[:sku_family], circuit_parameters[:sku_tier])
          service_provider_prop = create_express_route_service_provider_properties(circuit_parameters[:service_provider_name], circuit_parameters[:peering_location], circuit_parameters[:bandwidth_in_mbps])
          create_express_route_circuit(service_provider_prop, circuit_parameters[:peerings], circuit_parameters[:circuit_name], circuit_parameters[:location], sku, circuit_parameters[:tags])
        end

        def create_express_route_circuit_sku(sku_name, sku_family, sku_tier)
          sku = Azure::Network::Profiles::Latest::Mgmt::Models::ExpressRouteCircuitSku.new
          sku.name = sku_name
          sku.family = sku_family
          sku.tier = sku_tier
          sku
        end

        def create_express_route_service_provider_properties(service_provider_name, peering_location, bandwidth_in_mbps)
          service_provider_prop = Azure::Network::Profiles::Latest::Mgmt::Models::ExpressRouteCircuitServiceProviderProperties.new
          service_provider_prop.service_provider_name = service_provider_name
          service_provider_prop.peering_location = peering_location
          service_provider_prop.bandwidth_in_mbps = bandwidth_in_mbps
          service_provider_prop
        end

        def create_express_route_circuit(service_provider_prop, peerings, circuit_name, location, sku, tags)
          express_route_circuit = Azure::Network::Profiles::Latest::Mgmt::Models::ExpressRouteCircuit.new
          express_route_circuit.service_provider_properties = service_provider_prop
          express_route_circuit.peerings = get_circuit_peerings(peerings) if peerings
          express_route_circuit.name = circuit_name
          express_route_circuit.location = location
          express_route_circuit.sku = sku
          express_route_circuit.tags = tags
          express_route_circuit
        end

        def get_circuit_peerings(peerings)
          circuit_peerings = []
          peerings.each do |peering|
            circuit_peering_object = get_circuit_peering_object(peering)
            circuit_peerings.push(circuit_peering_object)
          end
          circuit_peerings
        end

        def create_express_route_circuit_peering(peering_type, peer_asn, primary_peer_address_prefix, secondary_peer_address_prefix, vlan_id, name)
          circuit_peering = Azure::Network::Profiles::Latest::Mgmt::Models::ExpressRouteCircuitPeering.new
          circuit_peering.peering_type = peering_type
          circuit_peering.peer_asn = peer_asn
          circuit_peering.primary_peer_address_prefix = primary_peer_address_prefix
          circuit_peering.secondary_peer_address_prefix = secondary_peer_address_prefix
          circuit_peering.vlan_id = vlan_id
          circuit_peering.name = name
          circuit_peering
        end

        def create_express_route_circuit_peering_config(advertised_public_prefixes, advertised_public_prefix_state, customer_asn, routing_registry_name)
          peering_config = Azure::Network::Profiles::Latest::Mgmt::Models::ExpressRouteCircuitPeeringConfig.new
          peering_config.advertised_public_prefixes = advertised_public_prefixes
          peering_config.advertised_public_prefixes_state = advertised_public_prefix_state
          peering_config.customer_asn = customer_asn
          peering_config.routing_registry_name = routing_registry_name
          peering_config
        end
      end

      # Mock class for Network Request
      class Mock
        def create_or_update_express_route_circuit(*)
          {
            'name' => 'CircuitName',
            'location' => 'eastus',
            'tags' => {
              'key1' => 'value1',
              'key2' => 'value2'
            },
            'sku' => {
              'name' => 'Standard_MeteredData',
              'tier' => 'Standard',
              'family' => 'MeteredData'
            },
            'properties' => {
              'serviceProviderProperties' => {
                'serviceProviderName' => 'Telenor',
                'peeringLocation' => 'London',
                'bandwidthInMbps' => 100
              }
            }
          }
        end
      end
    end
  end
end
