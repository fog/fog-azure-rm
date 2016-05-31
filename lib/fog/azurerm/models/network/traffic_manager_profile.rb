module Fog
  module Network
    class AzureRM
      # Traffic Manager Profile model for Network Service
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
          hash['id'] = profile['id']
          hash['name'] = profile['name']
          hash['resource_group'] = profile['id'].split('/')[4]
          hash['location'] = profile['location']
          hash['profile_status'] = profile['properties']['profileStatus']
          hash['traffic_routing_method'] = profile['properties']['trafficRoutingMethod']
          hash['relative_name'] = profile['properties']['dnsConfig']['relativeName']
          hash['fqdn'] = profile['properties']['dnsConfig']['fqdn']
          hash['ttl'] = profile['properties']['dnsConfig']['ttl']
          hash['profile_monitor_status'] = profile['properties']['monitorConfig']['profileMonitorStatus']
          hash['protocol'] = profile['properties']['monitorConfig']['protocol']
          hash['port'] = profile['properties']['monitorConfig']['port']
          hash['path'] = profile['properties']['monitorConfig']['path']
          hash['endpoints'] = []
          profile['properties']['endpoints'].each do |endpoint|
            end_point = Fog::Network::AzureRM::TrafficManagerEndPoint.new
            hash['endpoints'] << end_point.merge_attributes(Fog::Network::AzureRM::TrafficManagerEndPoint.parse(endpoint))
          end
          hash
        end

        def save
          requires :name, :resource_group, :traffic_routing_method, :relative_name, :ttl,
                   :protocol, :port, :path
          traffic_manager_profile = service.create_traffic_manager_profile(resource_group, name,
                                                                           traffic_routing_method, relative_name, ttl,
                                                                           protocol, port, path)
          merge_attributes(Fog::Network::AzureRM::TrafficManagerProfile.parse(traffic_manager_profile))
        end

        def destroy
          service.delete_traffic_manager_profile(resource_group, name)
        end
      end
    end
  end
end
