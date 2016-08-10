module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def create_or_update_express_route_circuit(resource_group_name, name, location, tag_key1, tag_key2, sku_name, sku_tier, sku_family, service_provider_name, peering_location, bandwidth_in_mbps, peerings)
          Fog::Logger.debug "Creating/Updating Express Route Circuit: #{name}..."
          circuit = get_express_route_circuit_object(name, location, sku_name, sku_tier, sku_family, service_provider_name, peering_location, bandwidth_in_mbps, peerings)
          begin
            promise = @network_client.express_route_circuits.create_or_update(resource_group_name, name, circuit)
            result = promise.value!
            Fog::Logger.debug "Express Route Circuit #{name} created/updated successfully."
            Azure::ARM::Network::Models::ExpressRouteCircuit.serialize_object(result.body)
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception creating/updating Express Route Circuit #{name} in Resource Group: #{resource_group_name}. #{e.body['error']['message']}"
            raise msg
          end
        end

        private

        def get_express_route_circuit_object(name, location, sku_name, sku_tier, sku_family, service_provider_name, peering_location, bandwidth_in_mbps, peerings)
          sku = Azure::ARM::Network::Models::ExpressRouteCircuitSku.new
          sku.name = sku_name
          sku.family = sku_family
          sku.tier = sku_tier

          service_provider_prop = Azure::ARM::Network::Models::ExpressRouteCircuitServiceProviderProperties.new
          service_provider_prop.service_provider_name = service_provider_name
          service_provider_prop.peering_location = peering_location
          service_provider_prop.bandwidth_in_mbps = bandwidth_in_mbps

          circuit_props = Azure::ARM::Network::Models::ExpressRouteCircuitPropertiesFormat.new
          circuit_props.service_provider_properties = service_provider_prop
          if peerings
            circuit_peering_arr = define_circuit_peerings(peerings)
            circuit_props.peerings = []
            circuit_props.peerings = circuit_peering_arr
          end

          express_route_circuit = Azure::ARM::Network::Models::ExpressRouteCircuit.new
          express_route_circuit.name = name
          express_route_circuit.location = location
          express_route_circuit.sku = sku
          express_route_circuit.properties = circuit_props

          express_route_circuit
        end

        def define_circuit_peerings(peerings)
          circuit_peering_arr = []
          peerings.each do |peering|
            circuit_peering = Azure::ARM::Network::Models::ExpressRouteCircuitPeering.new
            circuit_peering_prop = Azure::ARM::Network::Models::ExpressRouteCircuitPeeringPropertiesFormat.new
            circuit_peering_prop.peering_type = peering[:peering_type]
            circuit_peering_prop.peer_asn = peering[:peer_asn]
            circuit_peering_prop.primary_peer_address_prefix = peering[:primary_peer_address_prefix]
            circuit_peering_prop.secondary_peer_address_prefix = peering[:secondary_peer_address_prefix]
            circuit_peering_prop.vlan_id = peering[:vlan_id]

            circuit_peering.name = peering[:name]
            circuit_peering.properties = circuit_peering_prop
            circuit_peering_arr.push(circuit_peering)
          end
          circuit_peering_arr
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
