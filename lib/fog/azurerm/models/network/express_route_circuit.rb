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
          express_route_circuit_properties = circuit['properties']
          hash = {}
          hash['id'] = circuit['id']
          hash['name'] = circuit['name']
          hash['location'] = circuit['location']
          hash['service_key'] = circuit['serviceKey']
          hash['service_provider_notes'] = circuit['serviceProviderNotes']
          hash['resource_group'] = get_resource_group_from_id(circuit['id'])
          hash['resource_group'] = circuit['id'].split('/')[4]
          tags = circuit['tags']
          unless tags.nil?
            hash['tag_key1'] = tags['key1']
            hash['tag_key2'] = tags['key2']
          end
          sku = circuit['sku']
          unless sku.nil?
            hash['sku_name'] = sku['name']
            hash['sku_tier'] = sku['tier']
            hash['sku_family'] = sku['family']
          end
          hash['provisioning_state'] = express_route_circuit_properties['provisioningState']
          hash['circuit_provisioning_state'] = express_route_circuit_properties['circuitProvisioningState']
          hash['service_provider_provisioning_state'] = express_route_circuit_properties['serviceProviderProvisioningState']
          service_provider_properties = express_route_circuit_properties['serviceProviderProperties']
          unless service_provider_properties.nil?
            hash['service_provider_name'] = service_provider_properties['serviceProviderName']
            hash['peering_location'] = service_provider_properties['peeringLocation']
            hash['bandwidth_in_mbps'] = service_provider_properties['bandwidthInMbps']
          end
          hash['peerings'] = []
          express_route_circuit_properties['peerings'].each do |peering|
            circuit_peering = Fog::Network::AzureRM::ExpressRouteCircuitPeering.new
            hash['peerings'] << circuit_peering.merge_attributes(Fog::Network::AzureRM::ExpressRouteCircuitPeering.parse(peering))
          end unless express_route_circuit_properties['peerings'].nil?
          hash
        end

        def save
          requires :location, :tags, :resource_group, :service_provider_name, :peering_location, :bandwidth_in_mbps
          express_route_parameters = express_route_circuit_params
          circuit = service.create_or_update_express_route_circuit(express_route_parameters)
          merge_attributes(Fog::Network::AzureRM::ExpressRouteCircuit.parse(circuit))
        end

        def destroy
          service.delete_express_route_circuit(resource_group, name)
        end

        private

        def express_route_circuit_params
          express_route_parameters = {
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
          express_route_parameters
        end
      end
    end
  end
end
