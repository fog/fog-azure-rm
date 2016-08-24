module Fog
  module TrafficManager
    class AzureRM
      # Traffic Manager Profile Collection for TrafficManager Service
      class TrafficManagerProfiles < Fog::Collection
        attribute :resource_group
        model Fog::TrafficManager::AzureRM::TrafficManagerProfile

        def all
          requires :resource_group
          traffic_manager_profiles = []
          service.list_traffic_manager_profiles(resource_group).each do |profile|
            traffic_manager_profiles << Fog::TrafficManager::AzureRM::TrafficManagerProfile.parse(profile)
          end
          load(traffic_manager_profiles)
        end

        def get(identity)
          profile = service.get_traffic_manager_profile(resource_group, identity)
          profile_obj = Fog::TrafficManager::AzureRM::TrafficManagerProfile.new(service: service)
          profile_obj.merge_attributes(Fog::TrafficManager::AzureRM::TrafficManagerProfile.parse(profile))
        end
      end
    end
  end
end
