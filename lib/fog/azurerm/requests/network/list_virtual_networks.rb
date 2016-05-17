module Fog
  module Network
    class AzureRM
      class Real
        def list_virtual_networks(resource_group)
          begin
            response = @network_client.virtual_networks.list(resource_group)
            result = response.value!
            Azure::ARM::Network::Models::VirtualNetworkListResult.serialize_object(result.body)['value']
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception listing Virtual Networks. #{e.body['error']['message']}."
            raise msg
          end
        end
      end

      class Mock
        def list_virtual_networks(_resource_group)
          vnet = Azure::ARM::Network::Models::VirtualNetwork.new
          vnet.id = '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-resource-group/providers/Microsoft.Network/virtualNetworks/fogtestvnet'
          vnet.name = 'fogtestvnet'
          vnet.location = 'West US'
          vnet.properties = Azure::ARM::Network::Models::VirtualNetworkPropertiesFormat.new
          [vnet]
        end
      end
    end
  end
end
