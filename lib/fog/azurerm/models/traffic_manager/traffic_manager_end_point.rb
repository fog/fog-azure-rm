module Fog
  module TrafficManager
    class AzureRM
      # Traffic Manager End Point model for Traffic Manager Service
      class TrafficManagerEndPoint < Fog::Model
        identity :name
        attribute :traffic_manager_profile_name
        attribute :id
        attribute :resource_group
        attribute :type
        attribute :target_resource_id
        attribute :target
        attribute :endpoint_status
        attribute :endpoint_monitor_status
        attribute :weight
        attribute :priority
        attribute :endpoint_location
        attribute :min_child_endpoints

        def self.parse(endpoint)
          hash = {}
          hash['id'] = endpoint.id
          hash['name'] = endpoint.name
          hash['resource_group'] = get_resource_group_from_id(endpoint.id)
          hash['type'] = get_end_point_type(endpoint.type)
          hash['target_resource_id'] = endpoint.target_resource_id
          hash['target'] = endpoint.target
          hash['endpoint_status'] = endpoint.endpoint_status
          hash['endpoint_monitor_status'] = endpoint.endpoint_monitor_status
          hash['weight'] = endpoint.weight
          hash['priority'] = endpoint.priority
          hash['endpoint_location'] = endpoint.endpoint_location
          hash['min_child_endpoints'] = endpoint.min_child_endpoints
          hash['traffic_manager_profile_name'] = get_traffic_manager_profile_name_from_endpoint_id(endpoint.id)
          hash
        end

        def save
          requires :name, :traffic_manager_profile_name, :resource_group, :type
          requires :target_resource_id if type.eql?(AZURE_ENDPOINTS)
          requires :target, :endpoint_location if type.eql?(EXTERNAL_ENDPOINTS)
          requires :target_resource_id, :endpoint_location, :min_child_endpoints if type.eql?(NESTED_ENDPOINTS)

          create_or_update
        end

        def destroy
          service.delete_traffic_manager_endpoint(resource_group, name, traffic_manager_profile_name, type)
        end

        def update(endpoint_params)
          validate_input(endpoint_params)
          merge_attributes(endpoint_params)

          create_or_update
        end

        private

        def create_or_update
          if %w(azureEndpoints externalEndpoints nestedEndpoints).select { |type| type if type.eql?(type) }.any?
            traffic_manager_endpoint = service.create_or_update_traffic_manager_endpoint(traffic_manager_endpoint_hash)
            merge_attributes(Fog::TrafficManager::AzureRM::TrafficManagerEndPoint.parse(traffic_manager_endpoint))
          else
            raise(ArgumentError, ":type should be '#{AZURE_ENDPOINTS}', '#{EXTERNAL_ENDPOINTS}' or '#{NESTED_ENDPOINTS}'")
          end
        end

        def traffic_manager_endpoint_hash
          {
            resource_group: resource_group,
            name: name,
            traffic_manager_profile_name: traffic_manager_profile_name,
            type: type,
            target_resource_id: target_resource_id,
            target: target,
            weight: weight,
            priority: priority,
            endpoint_location: endpoint_location,
            min_child_endpoints: min_child_endpoints
          }
        end

        def validate_input(attr_hash)
          invalid_attr = [:resource_group, :name, :traffic_manager_profile_name, :id]
          result = invalid_attr & attr_hash.keys
          raise 'Cannot modify the given attribute' unless result.empty?
        end
      end
    end
  end
end
