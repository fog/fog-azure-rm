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
          unless frontend_ip_configuration.nil?
            unless frontend_ip_configuration.public_ipaddress.nil?
              hash['public_ip_address_id'] = frontend_ip_configuration.public_ipaddress.id
            end
            hash['private_ip_allocation_method'] = frontend_ip_configuration.private_ipallocation_method
            private_ip_address = frontend_ip_configuration.private_ipaddress
            unless private_ip_address.nil?
              hash['private_ip_address'] = private_ip_address
            end
          end
          hash
        end
      end
    end
  end
end
