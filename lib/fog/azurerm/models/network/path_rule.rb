module Fog
  module Network
    class AzureRM
      # Path Rule model class for Network Service
      class PathRule < Fog::Model
        attribute :paths
        attribute :backend_address_pool_id
        attribute :backend_http_settings_id

        def self.parse(path_rule)
          paths = path_rule['paths']

          hash = {}
          hash['paths'] = []
          paths.each do |path|
            hash['paths'] << path
          end unless paths.nil?

          unless path_rule['backendAddressPool'].nil?
            hash['backend_address_pool_id'] = path_rule['backendAddressPool']['id']
          end
          unless path_rule['backendHttpsettings'].nil?
            hash['backend_http_settings_id'] = path_rule['backendHttpsettings']['id']
          end
          hash
        end
      end
    end
  end
end
