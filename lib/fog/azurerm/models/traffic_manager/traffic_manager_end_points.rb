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

          traffic_manager_endpoints = []
          profile = service.get_traffic_manager_profile(resource_group, traffic_manager_profile_name)
          end_points = profile.endpoints
          end_points.each do |endpoint|
            traffic_manager_endpoints << TrafficManagerEndPoint.parse(endpoint)
          end
          load(traffic_manager_endpoints)
        end

        def get(resource_group, traffic_manager_profile_name, end_point_name, type)
          endpoint = service.get_traffic_manager_end_point(resource_group, traffic_manager_profile_name, end_point_name, type)
          endpoint_obj = TrafficManagerEndPoint.new(service: service)
          endpoint_obj.merge_attributes(TrafficManagerEndPoint.parse(endpoint))
        end
      end
    end
  end
end
