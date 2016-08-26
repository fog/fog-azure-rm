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
          hash['subnet_id'] = frontend_ip_configuration.subnet.id unless frontend_ip_configuration.subnet.nil?
          hash['private_ipaddress'] = frontend_ip_configuration.private_ipaddress if frontend_ip_configuration.respond_to?(:private_ipaddress)
          hash['private_ipallocation_method'] = frontend_ip_configuration.private_ipallocation_method unless frontend_ip_configuration.private_ipallocation_method.nil?
          hash['public_ip_address_id'] = frontend_ip_configuration.public_ipaddress unless frontend_ip_configuration.public_ipaddress.nil?
          hash
        end
      end
    end
  end
end
