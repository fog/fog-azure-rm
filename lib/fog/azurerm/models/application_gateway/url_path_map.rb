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
          hash = {}
          hash['name'] = url_path_map.name
          hash['default_backend_address_pool_id'] = url_path_map.default_backend_address_pool.id unless url_path_map.default_backend_address_pool.nil?
          hash['default_backend_http_settings_id'] = url_path_map.default_backend_http_settings.id unless url_path_map.default_backend_http_settings.nil?

          path_rules = url_path_map.path_rules
          hash['path_rules'] = []
          path_rules.each do |rule|
            path_rule = Fog::Network::AzureRM::PathRule.new
            hash['path_rules'] << path_rule.merge_attributes(Fog::Network::AzureRM::PathRule.parse(rule))
          end unless path_rules.nil?
          hash
        end
      end
    end
  end
end
