module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def get_subnet(resource_group, virtual_network_name, subnet_name)
          Fog::Logger.debug "Getting Subnet: #{subnet_name}."
          begin
            promise = @network_client.subnets.get(resource_group, virtual_network_name, subnet_name)
            result = promise.value!
            Fog::Logger.debug "Subnet #{subnet_name} retrieved successfully."
            Azure::ARM::Network::Models::Subnet.serialize_object(result.body)
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Exception getting Subnet #{subnet_name} in Resource Group: #{resource_group}. #{e.body['error']['message']}"
            raise msg
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def get_subnet(*)
          {
            'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog-rg/providers/Microsoft.Network/virtualNetworks/fog-vnet/subnets/fog-subnet',
            'properties' =>
              {
                'addressPrefix' => '10.1.0.0/24',
                'provisioningState' => 'Succeeded'
              },
            'name' => 'fog-subnet'
          }
        end
      end
    end
  end
end
