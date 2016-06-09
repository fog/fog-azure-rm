module Fog
  module Network
    class AzureRM
      # Path Rule model class for Network Service
      class PathRule < Fog::Model
        attribute :paths
        attribute :backendAddressPool
        attribute :backendHttpSettings

        def self.parse(path_rule)
          paths = path_rule['paths']

          hash = {}
          hash['paths'] = []
          paths.each do |path|
            hash['paths'] << path
          end unless paths.nil?

          unless path_rule['backendAddressPool'].nil?
            hash['backendAddressPool'] = path_rule['backendAddressPool']['id']
          end
          unless path_rule['backendHttpsettings'].nil?
            hash['backendHttpSettings'] = path_rule['backendHttpsettings']['id']
          end
          hash
        end
      end
    end
  end
end
