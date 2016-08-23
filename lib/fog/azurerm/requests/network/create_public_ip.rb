module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def create_public_ip(resource_group, name, location, public_ip_allocation_method)
          Fog::Logger.debug "Creating PublicIP #{name} in Resource Group #{resource_group}."
          public_ip = Azure::ARM::Network::Models::PublicIPAddress.new
          public_ip.name = name
          public_ip.location = location
          public_ip.public_ipallocation_method = public_ip_allocation_method
          begin
            public_ip = @network_client.public_ipaddresses.create_or_update(resource_group, name, public_ip)
            Fog::Logger.debug "PublicIP #{name} Created Successfully!"
            public_ip
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, "Creating PublicIP #{name} in Resource Group #{resource_group}")
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def create_public_ip(resource_group, name, location, public_ip_allocation_method)
          {
            'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/publicIPAddresses/#{name}",
            'name' => name,
            'type' => 'Microsoft.Network/publicIPAddresses',
            'location' => location,
            'properties' =>
              {
                'publicIPAllocationMethod' => public_ip_allocation_method,
                'ipAddress' => '13.91.253.67',
                'idleTimeoutInMinutes' => 4,
                'resourceGuid' => '767b1955-94de-433c-8e4a-ea0ad25e8d0c',
                'provisioningState' => 'Succeeded'
              }
          }
        end
      end
    end
  end
end
