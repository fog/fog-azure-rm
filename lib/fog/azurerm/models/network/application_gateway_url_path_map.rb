module Fog
  module Network
    class AzureRM
      # URL Path Map model class for Network Service
      class ApplicationGatewayUrlPathMap < Fog::Model
        identity :name
        attribute :defaultBackendAddressPool
        attribute :defaultBackendHttpSettings
        attribute :pathRules

        def self.parse(url_path_map)
          url_path_map_properties = url_path_map['properties']

          hash = {}
          hash['name'] = url_path_map['name']
          unless url_path_map_properties.nil?
            hash['defaultBackendAddressPool'] = url_path_map_properties['defaultBackendAddressPool']['id']
            hash['defaultBackendHttpSettings'] = url_path_map_properties['defaultBackendHttpSettings']['id']

            path_rules = url_path_map_properties['pathRules']
            hash['pathRules'] = []
            path_rules.each do |rule|
              path_rule = Fog::Network::AzureRM::PathRule.new
              hash['pathRules'] << path_rule.merge_attributes(Fog::Network::AzureRM::PathRule.parse(rule))
            end unless path_rules.nil?
          end
          hash
        end
      end
    end
  end
end
