module Fog
  module TrafficManager
    class AzureRM
      # Traffic Manager Profile model for TrafficManager Service
      class TrafficManagerProfile < Fog::Model
        identity :name
        attribute :id
        attribute :resource_group
        attribute :location
        attribute :profile_status
        attribute :traffic_routing_method
        attribute :relative_name
        attribute :fqdn
        attribute :ttl
        attribute :profile_monitor_status
        attribute :protocol
        attribute :port
        attribute :path
        attribute :endpoints

        def self.parse(profile)
          traffic_manager_profile = get_hash_from_object(profile)

          if profile.dns_config
            traffic_manager_profile['relative_name'] = profile.dns_config.relative_name
            traffic_manager_profile['fqdn'] = profile.dns_config.fqdn
            traffic_manager_profile['ttl'] = profile.dns_config.ttl
          end

          if profile.monitor_config
            traffic_manager_profile['profile_monitor_status'] = profile.monitor_config.profile_monitor_status
            traffic_manager_profile['protocol'] = profile.monitor_config.protocol
            traffic_manager_profile['port'] = profile.monitor_config.port
            traffic_manager_profile['path'] = profile.monitor_config.path
          end
          traffic_manager_profile['resource_group'] = get_resource_group_from_id(profile.id)
          traffic_manager_profile['endpoints'] = []
          profile.endpoints.each do |endpoint|
            end_point = Fog::TrafficManager::AzureRM::TrafficManagerEndPoint.new
            traffic_manager_profile['endpoints'] << end_point.merge_attributes(Fog::TrafficManager::AzureRM::TrafficManagerEndPoint.parse(endpoint))
          end
          traffic_manager_profile
        end

        def save
          requires :name, :resource_group, :traffic_routing_method, :relative_name, :ttl,
                   :protocol, :port, :path
          traffic_manager_profile = service.create_or_update_traffic_manager_profile(traffic_manager_profile_hash)
          merge_attributes(Fog::TrafficManager::AzureRM::TrafficManagerProfile.parse(traffic_manager_profile))
        end

        def destroy
          service.delete_traffic_manager_profile(resource_group, name)
        end

        def update(profile_params)
          validate_input(profile_params)
          merge_attributes(profile_params)
          profile = service.create_or_update_traffic_manager_profile(traffic_manager_profile_hash)
          merge_attributes(Fog::TrafficManager::AzureRM::TrafficManagerProfile.parse(profile))
        end

        private

        def validate_input(attr_hash)
          invalid_attr = [:resource_group, :name, :relative_name, :id]
          result = invalid_attr & attr_hash.keys
          raise 'Cannot modify the given attribute' unless result.empty?
        end

        def traffic_manager_profile_hash
          {
            resource_group: resource_group,
            name: name,
            traffic_routing_method: traffic_routing_method,
            relative_name: relative_name,
            ttl: ttl,
            protocol: protocol,
            port: port,
            path: path
          }
        end
      end
    end
  end
end
