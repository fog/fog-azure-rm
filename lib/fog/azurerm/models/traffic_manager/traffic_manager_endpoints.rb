module Fog
  module TrafficManager
    class AzureRM
      # Traffic Manager End Point Collection for TrafficManager Service
      class TrafficManagerEndPoints < Fog::Collection
        attribute :resource_group
        attribute :traffic_manager_profile_name
        model Fog::TrafficManager::AzureRM::TrafficManagerEndPoint

        def all
          requires :resource_group
          requires :traffic_manager_profile_name

          traffic_manager_endpoints = []
          profile = service.get_traffic_manager_profile(resource_group, traffic_manager_profile_name)
          end_points = profile['properties']['endpoints']
          end_points.each do |endpoint|
            traffic_manager_endpoints << Fog::TrafficManager::AzureRM::TrafficManagerEndPoint.parse(endpoint)
          end
          load(traffic_manager_endpoints)
        end

        def get(identity)
          endpoint = service.get_traffic_manager_profile(resource_group, identity)
          endpoint_obj = Fog::TrafficManager::AzureRM::TrafficManagerProfile.new(service: service)
          endpoint_obj.merge_attributes(Fog::TrafficManager::AzureRM::TrafficManagerProfile.parse(endpoint))
        end
      end
    end
  end
end
