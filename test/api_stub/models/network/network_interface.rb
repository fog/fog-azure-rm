module ApiStub
  module Models
    module Network
      class NetworkInterface
        def self.create_network_interface_response
          subnet = Azure::ARM::Network::Models::Subnet.new
          subnet.id = '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Network/virtualNetworks/fog-test-virtual-network/subnets/fog-test-subnet'
          ip_configs_props = Azure::ARM::Network::Models::NetworkInterfaceIPConfigurationPropertiesFormat.new
          ip_configs_props.private_ipallocation_method = 'fog-test-private-ip-allocation-method'
          ip_configs_props.subnet = subnet
          ip_configs = Azure::ARM::Network::Models::NetworkInterfaceIPConfiguration.new
          ip_configs.name = 'fog-test-ip-configuration'
          ip_configs.properties = ip_configs_props
          nic_props = Azure::ARM::Network::Models::NetworkInterfacePropertiesFormat.new
          nic_props.ip_configurations = [ip_configs]
          network_interface = Azure::ARM::Network::Models::NetworkInterface.new
          network_interface.name = 'fog-test-network-interface'
          network_interface.location = 'West US'
          network_interface.properties = nic_props

          network_interface
        end
      end
    end
  end
end
