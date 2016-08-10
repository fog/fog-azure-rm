module Fog
  module ApplicationGateway
    class AzureRM
      # Frontend IP Configuration model class for Network Service
      class FrontendIPConfiguration < Fog::Model
        identity :name
        attribute :public_ip_address_id
        attribute :private_ip_allocation_method
        attribute :private_ip_address
        def self.parse(frontend_ip_configuration)
          frontend_ip_configuration_properties = frontend_ip_configuration['properties']

          hash = {}
          hash['name'] = frontend_ip_configuration['name']
          unless frontend_ip_configuration_properties.nil?
            unless frontend_ip_configuration_properties['publicIPAddress'].nil?
              hash['public_ip_address_id'] = frontend_ip_configuration_properties['publicIPAddress']['id']
            end
            hash['private_ip_allocation_method'] = frontend_ip_configuration_properties['privateIPAllocationMethod']
            private_ip_address = frontend_ip_configuration_properties['privateIPAddress']
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
