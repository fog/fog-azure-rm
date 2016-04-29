module ApiStub
  module Models
    module Network
      class Subnet
        def self.create_subnet_response
          subnet = Azure::ARM::Network::Models::Subnet.new
          subnet.id = '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Network/virtualNetworks/fog-test-virtual-network/subnets/fog-test-subnet'
          subnet.name = 'fog-test-subnet'
          subnet.properties = Azure::ARM::Network::Models::SubnetPropertiesFormat.new
          subnet.properties.address_prefix = '10.1.0.0/24'

          subnet
        end
      end
    end
  end
end
