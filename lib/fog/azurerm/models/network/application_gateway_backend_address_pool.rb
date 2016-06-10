module Fog
  module Network
    class AzureRM
      # Backend Address Pool model class for Network Service
      class ApplicationGatewayBackendAddressPool < Fog::Model
        identity :name
        attribute :ipaddresses

        def self.parse(backend_address_pool)
          hash = {}
          unless backend_address_pool['properties'].nil?
            backend_addresses = backend_address_pool['properties']['backendAddresses']
            hash['name'] = backend_address_pool['name']
            hash['ipaddresses'] = []
            backend_addresses.each do |ip_address|
              hash['ipaddresses'] << ip_address
            end unless backend_addresses.nil?
          end
          hash
        end
      end
    end
  end
end
