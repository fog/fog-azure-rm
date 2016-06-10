module Fog
  module Network
    class AzureRM
      # Traffic Manager End Point model for Network Service
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
          hash['id'] = endpoint['id']
          hash['name'] = endpoint['name']
          hash['resource_group'] = endpoint['id'].split('/')[4]
          type = endpoint['type'].split('/')[2]
          type.slice!('Endpoints')
          hash['type'] = type
          hash['target_resource_id'] = endpoint['properties']['targetResourceId']
          hash['target'] = endpoint['properties']['target']
          hash['endpoint_status'] = endpoint['properties']['endpointStatus']
          hash['endpoint_monitor_status'] = endpoint['properties']['endpointMonitorStatus']
          hash['weight'] = endpoint['properties']['weight']
          hash['priority'] = endpoint['properties']['priority']
          hash['endpoint_location'] = endpoint['properties']['endpointLocation']
          hash['min_child_endpoints'] = endpoint['properties']['minChildEndpoints']
          hash
        end

        def save
          requires :name, :traffic_manager_profile_name, :resource_group, :type
          requires :target_resource_id if type.eql?('azure')
          requires :target, :endpoint_location if type.eql?('external')
          requires :target_resource_id, :endpoint_location, :min_child_endpoints if type.eql?('nested')

          if %w(azure external nested).select { |type| type if type.eql?(type) }.any?
            traffic_manager_endpoint = service.create_traffic_manager_endpoint(resource_group, name,
                                                                               traffic_manager_profile_name, type,
                                                                               target_resource_id, target, weight,
                                                                               priority, endpoint_location,
                                                                               min_child_endpoints)
            merge_attributes(Fog::Network::AzureRM::TrafficManagerEndPoint.parse(traffic_manager_endpoint))
          else
            raise(ArgumentError, ':type should be "azure", "external" or "nested"')
          end
        end

        def destroy
          service.delete_traffic_manager_endpoint(resource_group, name, traffic_manager_profile_name, type)
        end
      end
    end
  end
end
