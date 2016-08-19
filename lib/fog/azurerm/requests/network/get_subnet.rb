module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def get_subnet(resource_group, virtual_network_name, subnet_name)
          Fog::Logger.debug "Getting Subnet: #{subnet_name}."
          begin
            result = @network_client.subnets.get(resource_group, virtual_network_name, subnet_name)
            Fog::Logger.debug "Subnet #{subnet_name} retrieved successfully."
            result
          rescue  MsRestAzure::AzureOperationError => e
            raise Fog::AzureRm::OperationError.new(e)
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
