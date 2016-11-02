module Fog
  module Network
    class AzureRM
      # Express Route Circuit model class for Network Service
      class ExpressRouteCircuit < Fog::Model
        identity :name
        attribute :id
        attribute :location
        attribute :resource_group
        attribute :tags
        attribute :sku_name
        attribute :sku_tier
        attribute :sku_family
        attribute :service_provider_name
        attribute :provisioning_state
        attribute :circuit_provisioning_state
        attribute :service_provider_provisioning_state
        attribute :service_key
        attribute :service_provider_notes
        attribute :peering_location
        attribute :bandwidth_in_mbps
        attribute :peerings

        def self.parse(circuit)
          express_route_circuit = {}
          express_route_circuit['id'] = circuit.id
          express_route_circuit['name'] = circuit.name
          express_route_circuit['location'] = circuit.location
          express_route_circuit['service_key'] = circuit.service_key
          express_route_circuit['service_provider_notes'] = circuit.service_provider_notes
          express_route_circuit['resource_group'] = get_resource_group_from_id(circuit.id)
          express_route_circuit['tags'] = circuit.tags
          sku = circuit.sku
          unless sku.nil?
            express_route_circuit['sku_name'] = sku.name
            express_route_circuit['sku_tier'] = sku.tier
            express_route_circuit['sku_family'] = sku.family
          end
          express_route_circuit['provisioning_state'] = circuit.provisioning_state
          express_route_circuit['circuit_provisioning_state'] = circuit.circuit_provisioning_state
          express_route_circuit['service_provider_provisioning_state'] = circuit.service_provider_provisioning_state
          service_provider_properties = circuit.service_provider_properties
          unless service_provider_properties.nil?
            express_route_circuit['service_provider_name'] = service_provider_properties.service_provider_name
            express_route_circuit['peering_location'] = service_provider_properties.peering_location
            express_route_circuit['bandwidth_in_mbps'] = service_provider_properties.bandwidth_in_mbps
          end
          express_route_circuit['peerings'] = []
          circuit.peerings.each do |peering|
            circuit_peering = ExpressRouteCircuitPeering.new
            express_route_circuit['peerings'] << circuit_peering.merge_attributes(ExpressRouteCircuitPeering.parse(peering))
          end unless circuit.peerings.nil?
          express_route_circuit
        end

        def save
          requires :location, :tags, :resource_group, :service_provider_name, :peering_location, :bandwidth_in_mbps
          circuit = service.create_or_update_express_route_circuit(express_route_circuit_params)
          merge_attributes(ExpressRouteCircuit.parse(circuit))
        end

        def destroy
          service.delete_express_route_circuit(resource_group, name)
        end

        private

        def express_route_circuit_params
          {
            resource_group_name: resource_group,
            circuit_name: name,
            location: location,
            tags: tags,
            sku_name: sku_name,
            sku_tier: sku_tier,
            sku_family: sku_family,
            service_provider_name: service_provider_name,
            peering_location: peering_location,
            bandwidth_in_mbps: bandwidth_in_mbps,
            peerings: peerings
          }
        end
      end
    end
  end
end
