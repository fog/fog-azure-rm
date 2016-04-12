module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def create_network_interface(name, location, resource_group, subnet_id, ip_configurations_name, private_ip_allocation_method)
          network_interface = define_network_interface(name, location, subnet_id, ip_configurations_name, private_ip_allocation_method)
          begin
            promise = @network_client.network_interfaces.create_or_update(resource_group, name, network_interface)
            promise.value!
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception creating Network Interface: #{e.body}"
            fail msg
          end
        end

        private

        def define_network_interface(name, location, subnet_id, ip_configurations_name, private_ip_allocation_method)
          subnet = Azure::ARM::Network::Models::Subnet.new
          subnet.id = subnet_id

          ip_configurations_properties = Azure::ARM::Network::Models::NetworkInterfaceIPConfigurationPropertiesFormat.new
          ip_configurations_properties.private_ipallocation_method = private_ip_allocation_method
          ip_configurations_properties.subnet = subnet

          ip_configurations = Azure::ARM::Network::Models::NetworkInterfaceIPConfiguration.new
          ip_configurations.name = ip_configurations_name
          ip_configurations.properties = ip_configurations_properties

          network_interface_properties = Azure::ARM::Network::Models::NetworkInterfacePropertiesFormat.new
          network_interface_properties.ip_configurations = [ip_configurations]

          network_interface = Azure::ARM::Network::Models::NetworkInterface.new
          network_interface.name = name
          network_interface.location = location
          network_interface.properties = network_interface_properties

          network_interface
        end
      end

      # Mock class for Network Request
      class Mock
      end
    end
  end
end
