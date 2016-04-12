module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def list_network_interfaces(resource_group)
          puts "Getting list of NetworkInterfaces from Resource Group #{resource_group}."
          begin
            promise = @network_client.network_interfaces.list(resource_group)
            response = promise.value!
            result = response.body.value
            return result
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Error Getting list of NetworkInterfaces from ResourceGroup '#{resource_group}'. #{e.body}."
            fail msg
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def list_network_interfaces(_resource_group)
          nic = Azure::ARM::Network::Models::NetworkInterface.new
          nic.name = 'fogtestnetworkinterface'
          nic.location = 'West US'
          nic.properties = Azure::ARM::Network::Models::NetworkInterfacePropertiesFormat.new
          [nic]
        end
      end
    end
  end
end
