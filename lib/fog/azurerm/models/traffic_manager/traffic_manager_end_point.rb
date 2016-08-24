module Fog
  module TrafficManager
    class AzureRM
      # Traffic Manager End Point model for TrafficManager Service
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
          hash['type'] = endpoint.type.split('/')[2]
          hash['target_resource_id'] = endpoint.target_resource_id
          hash['target'] = endpoint.target
          hash['endpoint_status'] = endpoint.endpoint_status
          hash['endpoint_monitor_status'] = endpoint.endpoint_monitor_status
          hash['weight'] = endpoint.weight
          hash['priority'] = endpoint.priority
          hash['endpoint_location'] = endpoint.endpoint_location
          hash['min_child_endpoints'] = endpoint.min_child_endpoints
          hash['traffic_manager_profile_name'] = endpoint.id.split('/')[8]
          hash
        end

        def save
          requires :name, :traffic_manager_profile_name, :resource_group, :type
          requires :target_resource_id if type.eql?('azureEndpoints')
          requires :target, :endpoint_location if type.eql?('externalEndpoints')
          requires :target_resource_id, :endpoint_location, :min_child_endpoints if type.eql?('nestedEndpoints')

          if %w(azureEndpoints externalEndpoints nestedEndpoints).select { |type| type if type.eql?(type) }.any?
            traffic_manager_endpoint = service.create_traffic_manager_endpoint(resource_group, name,
                                                                               traffic_manager_profile_name, type,
                                                                               target_resource_id, target, weight,
                                                                               priority, endpoint_location,
                                                                               min_child_endpoints)
            merge_attributes(Fog::TrafficManager::AzureRM::TrafficManagerEndPoint.parse(traffic_manager_endpoint))
          else
            raise(ArgumentError, ':type should be "azureEndpoints", "externalEndpoints" or "nestedEndpoints"')
          end
        end

        def destroy
          service.delete_traffic_manager_endpoint(resource_group, name, traffic_manager_profile_name, type)
        end
      end
    end
  end
end
