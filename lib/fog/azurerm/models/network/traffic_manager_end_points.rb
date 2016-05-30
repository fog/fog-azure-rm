module Fog
  module Network
    class AzureRM
      # Traffic Manager End Point Collection for Network Service
      class TrafficManagerEndPoints < Fog::Collection
        attribute :resource_group
        attribute :traffic_manager_profile_name
        model Fog::Network::AzureRM::TrafficManagerEndPoint

        def all
          requires :resource_group
          requires :traffic_manager_profile_name

          traffic_manager_endpoints = []
          profile = service.get_traffic_manager_profile(resource_group, traffic_manager_profile_name)
          end_points = profile['properties']['endpoints']
          end_points.each do |endpoint|
            traffic_manager_endpoints << Fog::Network::AzureRM::TrafficManagerEndPoint.parse(endpoint)
          end
          load(traffic_manager_endpoints)
        end

        def get(identity)
          all.find { |ep| ep.name == identity }
        end
      end
    end
  end
end
