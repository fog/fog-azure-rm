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
          hash = {}
          hash['id'] = profile.id
          hash['name'] = profile.name
          hash['resource_group'] = get_resource_group_from_id(profile.id)
          hash['location'] = profile.location
          hash['profile_status'] = profile.profile_status
          hash['traffic_routing_method'] = profile.traffic_routing_method
          hash['relative_name'] = profile.dns_config.relative_name
          hash['fqdn'] = profile.dns_config.fqdn
          hash['ttl'] = profile.dns_config.ttl
          hash['profile_monitor_status'] = profile.monitor_config.profile_monitor_status
          hash['protocol'] = profile.monitor_config.protocol
          hash['port'] = profile.monitor_config.port
          hash['path'] = profile.monitor_config.path
          hash['endpoints'] = []
          profile.endpoints.each do |endpoint|
            end_point = Fog::TrafficManager::AzureRM::TrafficManagerEndPoint.new
            hash['endpoints'] << end_point.merge_attributes(Fog::TrafficManager::AzureRM::TrafficManagerEndPoint.parse(endpoint))
          end
          hash
        end

        def save
          requires :name, :resource_group, :traffic_routing_method, :relative_name, :ttl,
                   :protocol, :port, :path
          traffic_manager_profile = service.create_or_update_traffic_manager_profile(resource_group, name, traffic_routing_method, relative_name, ttl, protocol, port, path)
          merge_attributes(Fog::TrafficManager::AzureRM::TrafficManagerProfile.parse(traffic_manager_profile))
        end

        def destroy
          service.delete_traffic_manager_profile(resource_group, name)
        end

        def update(profile_params)
          validate_input(profile_params)
          merge_attributes(profile_params)
          profile = service.create_or_update_traffic_manager_profile(resource_group, name, traffic_routing_method, relative_name, ttl, protocol, port, path)
          merge_attributes(Fog::TrafficManager::AzureRM::TrafficManagerProfile.parse(profile))
        end

        private

        def validate_input(attr_hash)
          invalid_attr = [:resource_group, :name, :relative_name, :id]
          result = invalid_attr & attr_hash.keys
          raise 'Cannot modify the given attribute' unless result.empty?
        end
      end
    end
  end
end
