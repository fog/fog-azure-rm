module Fog
  module ApplicationGateway
    class AzureRM
      # GatewayIPConfiguration model class for Network Service
      class IPConfiguration < Fog::Model
        identity :name
        attribute :subnet_id

        def self.parse(gateway_ip_configuration)
          hash = {}
          hash['name'] = gateway_ip_configuration['name']
          gateway_ip_configuration_prop = gateway_ip_configuration['properties']
          unless gateway_ip_configuration_prop['subnet'].nil?
            hash['subnet_id'] = gateway_ip_configuration_prop['subnet']['id']
          end
          hash
        end
      end
    end
  end
end
