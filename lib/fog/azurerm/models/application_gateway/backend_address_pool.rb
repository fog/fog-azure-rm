module Fog
  module ApplicationGateway
    class AzureRM
      # Backend Address Pool model class for Network Service
      class BackendAddressPool < Fog::Model
        identity :name
        attribute :ip_addresses

        def self.parse(backend_address_pool)
          hash = {}
          unless backend_address_pool['properties'].nil?
            backend_addresses = backend_address_pool['properties']['backendAddresses']
            hash['name'] = backend_address_pool['name']
            hash['ip_addresses'] = []
            backend_addresses.each do |ip_address|
              hash['ip_addresses'] << ip_address
            end unless backend_addresses.nil?
          end
          hash
        end
      end
    end
  end
end
