module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def get_subnet(resource_group, virtual_network_name, subnet_name)
          msg = "Getting Subnet: #{subnet_name}."
          Fog::Logger.debug msg
          begin
            subnet = @network_client.subnets.get(resource_group, virtual_network_name, subnet_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Subnet #{subnet_name} retrieved successfully."
          subnet
        end
      end

      # Mock class for Network Request
      class Mock
        def get_subnet(*)
          subnet = {
            'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog-rg/providers/Microsoft.Network/virtualNetworks/fog-vnet/subnets/fog-subnet',
            'properties' =>
              {
                'addressPrefix' => '10.1.0.0/24',
                'provisioningState' => 'Succeeded'
              },
            'name' => 'fog-subnet'
          }
          subnet_mapper = Azure::Network::Profiles::Latest::Mgmt::Models::Subnet.mapper
          @network_client.deserialize(subnet_mapper, subnet, 'result.body')
        end
      end
    end
  end
end
