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
          end_points = profile.endpoints
          end_points.each do |endpoint|
            traffic_manager_endpoints << Fog::TrafficManager::AzureRM::TrafficManagerEndPoint.parse(endpoint)
          end
          load(traffic_manager_endpoints)
        end

        def get(resource_group, traffic_manager_profile_name, end_point_name, type)
          endpoint = service.get_traffic_manager_end_point(resource_group, traffic_manager_profile_name, end_point_name, type)
          endpoint_obj = Fog::TrafficManager::AzureRM::TrafficManagerEndPoint.new(service: service)
          endpoint_obj.merge_attributes(Fog::TrafficManager::AzureRM::TrafficManagerEndPoint.parse(endpoint))
        end
      end
    end
  end
end
