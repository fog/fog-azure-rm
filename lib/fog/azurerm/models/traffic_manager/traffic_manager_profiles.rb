module Fog
  module TrafficManager
    class AzureRM
      # Traffic Manager Profile Collection for TrafficManager Service
      class TrafficManagerProfiles < Fog::Collection
        attribute :resource_group
        model TrafficManagerProfile

        def all
          requires :resource_group
          traffic_manager_profiles = service.list_traffic_manager_profiles(resource_group).map { |profile| TrafficManagerProfile.parse(profile) }
          load(traffic_manager_profiles)
        end

        def get(resource_group, traffic_manager_profile_name)
          profile = service.get_traffic_manager_profile(resource_group, traffic_manager_profile_name)
          profile_fog = TrafficManagerProfile.new(service: service)
          profile_fog.merge_attributes(TrafficManagerProfile.parse(profile))
        end
      end
    end
  end
end
