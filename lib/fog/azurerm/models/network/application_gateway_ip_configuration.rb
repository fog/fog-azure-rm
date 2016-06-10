module Fog
  module Network
    class AzureRM
      # GatewayIPConfiguration model class for Network Service
      class ApplicationGatewayIPConfiguration < Fog::Model
        identity :name
        attribute :subnet

        def self.parse(gateway_ip_configuration)
          hash = {}
          hash['name'] = gateway_ip_configuration['name']
          gateway_ip_configuration_prop = gateway_ip_configuration['properties']
          unless gateway_ip_configuration_prop['subnet'].nil?
            hash['subnet'] = gateway_ip_configuration_prop['subnet']['id']
          end
          hash
        end
      end
    end
  end
end
