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
          hash = {}
          hash['id'] = service_provider['id']
          hash['name'] = service_provider['name']

          hash['peering_locations'] = []
          unless service_provider['peeringLocations'].nil?
            service_provider['peeringLocations'].each do |peering_location|
              hash['peering_locations'] << peering_location
            end unless service_provider['peeringLocations'].nil?
          end
          hash['bandwidths_offered'] = []
          unless service_provider['bandwidthsOffered'].nil?
            service_provider['bandwidthsOffered'].each do |bandwidth_offered|
              hash['bandwidths_offered'] << bandwidth_offered
            end unless service_provider['bandwidthsOffered'].nil?
          end
          hash
        end
      end
    end
  end
end
