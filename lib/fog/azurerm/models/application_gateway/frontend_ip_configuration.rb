module Fog
  module ApplicationGateway
    class AzureRM
      # Frontend IP Configuration model class for Application Gateway Service
      class FrontendIPConfiguration < Fog::Model
        identity :name
        attribute :public_ip_address_id
        attribute :private_ip_allocation_method
        attribute :private_ip_address
        def self.parse(frontend_ip_configuration)
          hash = {}
          hash['name'] = frontend_ip_configuration.name
          hash['public_ip_address_id'] = frontend_ip_configuration.public_ipaddress.id unless frontend_ip_configuration.public_ipaddress.nil?
          hash['private_ip_allocation_method'] = frontend_ip_configuration.private_ipallocation_method
          private_ip_address = frontend_ip_configuration.private_ipaddress
          hash['private_ip_address'] = private_ip_address
          hash
        end
      end
    end
  end
end
