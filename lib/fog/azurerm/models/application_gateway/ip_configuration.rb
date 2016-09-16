module Fog
  module ApplicationGateway
    class AzureRM
      # GatewayIPConfiguration model class for Application Gateway Service
      class IPConfiguration < Fog::Model
        identity :name
        attribute :subnet_id

        def self.parse(gateway_ip_configuration)
          hash = {}
          if gateway_ip_configuration.is_a? Hash
            hash['name'] = gateway_ip_configuration['name']
            hash['subnet_id'] = gateway_ip_configuration['subnet']['id'] unless gateway_ip_configuration['subnet'].nil?
          else
            hash['name'] = gateway_ip_configuration.name
            hash['subnet_id'] = gateway_ip_configuration.subnet.id unless gateway_ip_configuration.subnet.nil?
          end
          hash
        end
      end
    end
  end
end
