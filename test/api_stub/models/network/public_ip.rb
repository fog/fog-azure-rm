module ApiStub
  module Models
    module Network
      class PublicIp
        def self.create_public_ip_response
          public_ip = Azure::ARM::Network::Models::PublicIPAddress.new
          public_ip.name = 'fog-test-public-ip'
          public_ip.location = 'West US'
          public_ip.properties = Azure::ARM::Network::Models::PublicIPAddressPropertiesFormat.new
          public_ip.properties.public_ipallocation_method = 'Dynamic'

          public_ip
        end
      end
    end
  end
end
