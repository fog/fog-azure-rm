module Fog
  module ApplicationGateway
    class AzureRM
      # Backend Address Pool model class for Application Gateway Service
      class BackendAddressPool < Fog::Model
        identity :name
        attribute :id
        attribute :ip_addresses

        def self.parse(backend_address_pool)
          hash = {}
          backend_addresses = backend_address_pool.backend_addresses
          hash['id'] = backend_address_pool.id
          hash['name'] = backend_address_pool.name
          hash['ip_addresses'] = []
          backend_addresses.each do |ip_address|
            hash['ip_addresses'] << ip_address
          end unless backend_addresses.nil?
          hash
        end
      end
    end
  end
end
