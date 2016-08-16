module Fog
  module ApplicationGateway
    class AzureRM
      # URL Path Map model class for Application Gateway Service
      class UrlPathMap < Fog::Model
        identity :name
        attribute :default_backend_address_pool_id
        attribute :default_backend_http_settings_id
        attribute :path_rules

        def self.parse(url_path_map)
          url_path_map_properties = url_path_map['properties']

          hash = {}
          hash['name'] = url_path_map['name']
          unless url_path_map_properties.nil?
            hash['default_backend_address_pool_id'] = url_path_map_properties['defaultBackendAddressPool']['id']
            hash['default_backend_http_settings_id'] = url_path_map_properties['defaultBackendHttpSettings']['id']

            path_rules = url_path_map_properties['pathRules']
            hash['path_rules'] = []
            path_rules.each do |rule|
              path_rule = Fog::Network::AzureRM::PathRule.new
              hash['path_rules'] << path_rule.merge_attributes(Fog::Network::AzureRM::PathRule.parse(rule))
            end unless path_rules.nil?
          end
          hash
        end
      end
    end
  end
end
