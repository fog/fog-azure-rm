module Fog
  module Network
    class AzureRM
      # Express Route Service Provider model class for Network Service
      class ExpressRouteServiceProvider < Fog::Model
        identity :name
        attribute :id
        attribute :peering_locations
        attribute :bandwidths_offered

        def self.parse(service_provider)
          express_route_service_provider = {}
          express_route_service_provider['id'] = service_provider.id
          express_route_service_provider['name'] = service_provider.name

          express_route_service_provider['peering_locations'] = []
          service_provider.peering_locations.each do |peering_location|
            express_route_service_provider['peering_locations'] << peering_location
          end unless service_provider.peering_locations.nil?
          express_route_service_provider['bandwidths_offered'] = []
          service_provider.bandwidths_offered.each do |bandwidth_offered|
            express_route_service_provider['bandwidths_offered'] << bandwidth_offered
          end unless service_provider.bandwidths_offered.nil?
          express_route_service_provider
        end
      end
    end
  end
end
