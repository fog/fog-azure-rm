module Fog
  module Network
    class AzureRM
      # Traffic Manager Profile Collection for Network Service
      class TrafficManagerProfiles < Fog::Collection
        attribute :resource_group
        model Fog::Network::AzureRM::TrafficManagerProfile

        def all
          requires :resource_group
          traffic_manager_profiles = []
          service.list_traffic_manager_profiles(resource_group).each do |profile|
            traffic_manager_profiles << Fog::Network::AzureRM::TrafficManagerProfile.parse(profile)
          end
          load(traffic_manager_profiles)
        end

        def get(identity)
          all.find { |p| p.name == identity }
        end
      end
    end
  end
end
