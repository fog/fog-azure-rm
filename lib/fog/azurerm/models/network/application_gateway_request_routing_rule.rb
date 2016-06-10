module Fog
  module Network
    class AzureRM
      # Request Routing Rule model class for Network Service
      class ApplicationGatewayRequestRoutingRule < Fog::Model
        identity :name
        attribute :type
        attribute :http_listener_id
        attribute :backend_address_pool_id
        attribute :backend_http_settings_id
        attribute :url_path_map

        def self.parse(request_routing_rule)
          request_routing_rule_properties = request_routing_rule['properties']

          hash = {}
          hash['name'] = request_routing_rule['name']
          unless request_routing_rule_properties.nil?
            hash['type'] = request_routing_rule_properties['ruleType']
            unless request_routing_rule_properties['httpListener'].nil?
              hash['http_listener_id'] = request_routing_rule_properties['httpListener']['id']
            end
            unless request_routing_rule_properties['backendAddressPool'].nil?
              hash['backend_address_pool_id'] = request_routing_rule_properties['backendAddressPool']['id']
            end
            unless request_routing_rule_properties['backendHttpSettings'].nil?
              hash['backend_http_settings_id'] = request_routing_rule_properties['backendHttpSettings']['id']
            end
          end
          hash
        end
      end
    end
  end
end
