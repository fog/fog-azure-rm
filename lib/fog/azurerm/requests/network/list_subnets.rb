module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def list_subnets(resource_group_name, virtual_network_name)
          begin
            response = @network_client.subnets.list(resource_group_name, virtual_network_name)
            result = response.value!
            result.body.value
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception listing Subnets: #{e.body['error']['message']}"
            fail msg
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def list_subnets(resource_group_name, virtual_network_name)
          subnet = Azure::ARM::Network::Models::Subnet.new
          subnet.id = "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group_name}/providers/Microsoft.Network/virtualNetworks/#{virtual_network_name}/subnets/fogtestsubnet"
          subnet.name = 'fogtestsubnet'
          subnet.properties = Azure::ARM::Network::Models::SubnetPropertiesFormat.new
          [subnet]
        end
      end
    end
  end
end
