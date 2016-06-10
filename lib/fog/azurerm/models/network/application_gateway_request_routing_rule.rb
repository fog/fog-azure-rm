module Fog
  module Network
    class AzureRM
      # Request Routing Rule model class for Network Service
      class ApplicationGatewayRequestRoutingRule < Fog::Model
        identity :name
        attribute :type
        attribute :httpListener
        attribute :backendAddressPool
        attribute :backendHttpSettings
        attribute :urlPathMap

        def self.parse(request_routing_rule)
          request_routing_rule_properties = request_routing_rule['properties']

          hash = {}
          hash['name'] = request_routing_rule['name']
          unless request_routing_rule_properties.nil?
            hash['type'] = request_routing_rule_properties['ruleType']
            unless request_routing_rule_properties['httpListener'].nil?
              hash['httpListener'] = request_routing_rule_properties['httpListener']['id']
            end
            unless request_routing_rule_properties['backendAddressPool'].nil?
              hash['backendAddressPool'] = request_routing_rule_properties['backendAddressPool']['id']
            end
            unless request_routing_rule_properties['backendHttpSettings'].nil?
              hash['backendHttpSettings'] = request_routing_rule_properties['backendHttpSettings']['id']
            end
          end
          hash
        end
      end
    end
  end
end
