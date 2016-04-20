module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def list_subnets(resource_group_name, virtual_network_name)
          begin
            promise = @network_client.subnets.list(resource_group_name, virtual_network_name)
            response = promise.value!
            response.body.value
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception listing Subnets from Resource Group '#{resource_group}' in Virtal Network #{virtual_network_name}. #{e.body['error']['message']}."
            raise msg
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
