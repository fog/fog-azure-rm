module Fog
  module Network
    class AzureRM
      # Express Route Circuit model class for Network Service
      class ExpressRouteCircuit < Fog::Model
        identity :name
        attribute :id
        attribute :location
        attribute :resource_group
        attribute :tag_key1
        attribute :tag_key2
        attribute :sku_name
        attribute :sku_tier
        attribute :sku_family
        attribute :service_provider_name
        attribute :provisioning_state
        attribute :circuit_provisioning_state
        attribute :service_provider_provisioning_State
        attribute :service_key
        attribute :service_provider_notes
        attribute :peering_location
        attribute :bandwidth_in_mbps
        attribute :peerings

        def self.parse(circuit)
          express_route_circuit_properties = circuit['properties']
          hash = {}
          hash['id'] = circuit['id']
          hash['name'] = circuit['name']
          hash['location'] = circuit['location']
          hash['service_key'] = circuit['serviceKey']
          hash['service_provider_notes'] = circuit['serviceProviderNotes']
          hash['resource_group'] = circuit['id'].split('/')[4]
          unless circuit['tags'].nil?
            hash['tag_key1'] = circuit['tags']['key1']
            hash['tag_key1'] = circuit['tags']['key2']
          end
          unless circuit['sku'].nil?
            hash['sku_name'] = circuit['sku']['name']
            hash['sku_tier'] = circuit['sku']['tier']
            hash['sku_family'] = circuit['sku']['family']
          end
          hash['provisioning_state'] = express_route_circuit_properties['provisioningState']
          hash['circuit_provisioning_state'] = express_route_circuit_properties['circuitProvisioningState']
          hash['service_provider_provisioning_State'] = express_route_circuit_properties['serviceProviderProvisioningState']
          unless express_route_circuit_properties['serviceProviderProperties'].nil?
            hash['service_provider_name'] = express_route_circuit_properties['serviceProviderProperties']['serviceProviderName']
            hash['peering_location'] = express_route_circuit_properties['serviceProviderProperties']['peeringLocation']
            hash['bandwidth_in_mbps'] = express_route_circuit_properties['serviceProviderProperties']['bandwidthInMbps']
          end
          unless express_route_circuit_properties['peerings'].nil?
            hash['peerings'] = []
            express_route_circuit_properties['peerings'].each do |peering|
              circuit_peering = Fog::Network::AzureRM::ExpressRouteCircuitPeering.new
              hash['peerings'] << circuit_peering.merge_attributes(Fog::Network::AzureRM::ExpressRouteCircuitPeering.parse(peering))
            end unless express_route_circuit_properties['peerings'].nil?
          end
          hash
        end

        def save
          requires :location, :resource_group, :service_provider_name, :peering_location, :bandwidth_in_mbps
          circuit = service.create_or_update_express_route_circuit(resource_group, name, location, tag_key1, tag_key2, sku_name, sku_tier, sku_family, service_provider_name, peering_location, bandwidth_in_mbps, peerings)
          merge_attributes(Fog::Network::AzureRM::ExpressRouteCircuit.parse(circuit))
        end

        def destroy
          service.delete_express_route_circuit(resource_group, name)
        end
      end
    end
  end
end
