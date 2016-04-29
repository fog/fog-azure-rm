module ApiStub
  module Models
    module Network
      class VirtualNetwork
        def self.create_virtual_network_response
          subnet_properties = Azure::ARM::Network::Models::SubnetPropertiesFormat.new
          subnet_properties.address_prefix = ['10.1.0.0/24']
          subnet = Azure::ARM::Network::Models::Subnet.new
          subnet.name = 'fog-test-subnet'
          subnet.properties = subnet_properties
          address_space = Azure::ARM::Network::Models::AddressSpace.new
          address_space.address_prefixes = ['10.2.0.0/16']
          dhcp_options = Azure::ARM::Network::Models::DhcpOptions.new
          dhcp_options.dns_servers = ['10.1.0.0/16,10.2.0.0/16']
          virtual_network_properties = Azure::ARM::Network::Models::VirtualNetworkPropertiesFormat.new
          virtual_network_properties.address_space = address_space
          virtual_network_properties.dhcp_options = dhcp_options
          virtual_network_properties.subnets = [subnet]
          virtual_network = Azure::ARM::Network::Models::VirtualNetwork.new
          virtual_network.name = 'fog-test-virtual-network'
          virtual_network.id = '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Network/virtualNetworks/fog-test-virtual-network'
          virtual_network.location = 'West US'
          virtual_network.properties = virtual_network_properties

          virtual_network
        end
      end
    end
  end
end
