module Fog
  module Network
    class AzureRM
      # FrontendIPConfiguration model for Network Service
      class FrontendIPConfiguration < Fog::Model
        identity :name
        attribute :id
        attribute :load_balancing_rules
        attribute :private_ipaddress
        attribute :private_ipallocation_method
        attribute :subnet_id
        attribute :public_ipaddress_id

        def self.parse(frontend_ip_configuration)
          hash = {}
          hash['name'] = frontend_ip_configuration.name
          subnet = frontend_ip_configuration.subnet
          hash['subnet_id'] = subnet.id unless subnet.nil?
          private_ip_address = frontend_ip_configuration.private_ipaddress
          unless private_ip_address.nil?
            hash['private_ipaddress'] = private_ip_address
          end
          private_ipallocation_method = frontend_ip_configuration.private_ipallocation_method
          unless private_ipallocation_method.nil?
            hash['private_ipallocation_method'] = private_ipallocation_method
          end
          public_ip_address = frontend_ip_configuration.public_ipaddress
          unless public_ip_address.nil?
            hash['public_ip_address_id'] = public_ip_address.id
          end
          hash
        end
      end
    end
  end
end
