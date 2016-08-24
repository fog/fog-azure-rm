module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def create_or_update_express_route_circuit(circuit_parameters)
          msg = "Exception creating/updating Express Route Circuit #{circuit_parameters[:circuit_name]} in Resource Group: #{circuit_parameters[:resource_group_name]}."
          Fog::Logger.debug msg
          circuit = get_express_route_circuit_object(circuit_parameters)
          begin
            circuit = @network_client.express_route_circuits.create_or_update(circuit_parameters[:resource_group_name], circuit_parameters[:circuit_name], circuit).value!
            Fog::Logger.debug "Express Route Circuit #{circuit_parameters[:circuit_name]} created/updated successfully."
            Azure::ARM::Network::Models::ExpressRouteCircuit.serialize_object(circuit.body)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
        end

        private

        def get_express_route_circuit_object(circuit_parameters)
          sku = Azure::ARM::Network::Models::ExpressRouteCircuitSku.new
          sku.name = circuit_parameters[:sku_name]
          sku.family = circuit_parameters[:sku_family]
          sku.tier = circuit_parameters[:sku_tier]

          service_provider_prop = Azure::ARM::Network::Models::ExpressRouteCircuitServiceProviderProperties.new
          service_provider_prop.service_provider_name = circuit_parameters[:service_provider_name]
          service_provider_prop.peering_location = circuit_parameters[:peering_location]
          service_provider_prop.bandwidth_in_mbps = circuit_parameters[:bandwidth_in_mbps]

          circuit_props = Azure::ARM::Network::Models::ExpressRouteCircuitPropertiesFormat.new
          circuit_props.service_provider_properties = service_provider_prop
          if circuit_parameters[:peerings]
            circuit_peerings = get_circuit_peerings(circuit_parameters[:peerings])
            circuit_props.peerings = circuit_peerings
          end

          express_route_circuit = Azure::ARM::Network::Models::ExpressRouteCircuit.new
          express_route_circuit.name = circuit_parameters[:circuit_name]
          express_route_circuit.location = circuit_parameters[:location]
          express_route_circuit.sku = sku
          express_route_circuit.tags = circuit_parameters[:tags] if express_route_circuit.tags.nil?
          express_route_circuit.properties = circuit_props

          express_route_circuit
        end

        def get_circuit_peerings(peerings)
          circuit_peerings = []
          peerings.each do |peering|
            circuit_peering = Azure::ARM::Network::Models::ExpressRouteCircuitPeering.new
            circuit_peering_prop = Azure::ARM::Network::Models::ExpressRouteCircuitPeeringPropertiesFormat.new
            circuit_peering_prop.peering_type = peering[:peering_type]
            circuit_peering_prop.peer_asn = peering[:peer_asn]
            circuit_peering_prop.primary_peer_address_prefix = peering[:primary_peer_address_prefix]
            circuit_peering_prop.secondary_peer_address_prefix = peering[:secondary_peer_address_prefix]
            circuit_peering_prop.vlan_id = peering[:vlan_id]
            if peering[:peering_type].casecmp(MICROSOFT_PEERING) == 0
              peering_config = Azure::ARM::Network::Models::ExpressRouteCircuitPeeringConfig.new
              peering_config.advertised_public_prefixes = peering[:advertised_public_prefixes]
              peering_config.advertised_public_prefixes_state = peering[:advertised_public_prefix_state]
              peering_config.customer_asn = peering[:customer_asn]
              peering_config.routing_registry_name = peering[:routing_registry_name]
              circuit_peering_prop.microsoft_peering_config = peering_config
            end

            if peering[:peering_type].casecmp(MICROSOFT_PEERING) == 0
              peering_config = Azure::ARM::Network::Models::ExpressRouteCircuitPeeringConfig.new
              peering_config.advertised_public_prefixes = peering[:advertised_public_prefixes]
              peering_config.advertised_public_prefixes_state = peering[:advertised_public_prefix_state]
              peering_config.customer_asn = peering[:customer_asn]
              peering_config.routing_registry_name = peering[:routing_registry_name]
              circuit_peering_prop.microsoft_peering_config = peering_config
            end

            circuit_peering.name = peering[:name]
            circuit_peering.properties = circuit_peering_prop
            circuit_peerings.push(circuit_peering)
          end
          circuit_peerings
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
