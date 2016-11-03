module Fog
  module TrafficManager
    class AzureRM
      # Traffic Manager End Point Collection for TrafficManager Service
      class TrafficManagerEndPoints < Fog::Collection
        attribute :resource_group
        attribute :traffic_manager_profile_name
        model TrafficManagerEndPoint

        def all
          requires :resource_group, :traffic_manager_profile_name

          end_points = service.get_traffic_manager_profile(resource_group, traffic_manager_profile_name).endpoints
          traffic_manager_endpoints = end_points.map { |endpoint| TrafficManagerEndPoint.parse(endpoint) }
          load(traffic_manager_endpoints)
        end

        def get(resource_group, traffic_manager_profile_name, end_point_name, type)
          endpoint = service.get_traffic_manager_end_point(resource_group, traffic_manager_profile_name, end_point_name, type)
          endpoint_fog = TrafficManagerEndPoint.new(service: service)
          endpoint_fog.merge_attributes(TrafficManagerEndPoint.parse(endpoint))
        end
      end
    end
  end
end
