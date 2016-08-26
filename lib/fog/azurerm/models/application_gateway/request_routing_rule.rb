module Fog
  module ApplicationGateway
    class AzureRM
      # Request Routing Rule model class for Application Gateway Service
      class RequestRoutingRule < Fog::Model
        identity :name
        attribute :type
        attribute :http_listener_id
        attribute :backend_address_pool_id
        attribute :backend_http_settings_id
        attribute :url_path_map

        def self.parse(request_routing_rule)
          hash = {}
          hash['name'] = request_routing_rule.name
          hash['type'] = request_routing_rule.rule_type
          hash['http_listener_id'] = request_routing_rule.http_listener.id unless request_routing_rule.http_listener.nil?
          hash['backend_address_pool_id'] = request_routing_rule.backend_address_pool.id unless request_routing_rule.backend_address_pool.nil?
          hash['backend_http_settings_id'] = request_routing_rule.backend_http_settings.id unless request_routing_rule.backend_http_settings.nil?
          hash
        end
      end
    end
  end
end
