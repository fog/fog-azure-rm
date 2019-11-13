module Fog
  module Network
    class AzureRM
      # Real class for Network Gateway Request
      class Real
        def get_virtual_network_gateway(resource_group_name, network_gateway_name)
          msg = "Getting Virtual Network Gateway #{network_gateway_name} from Resource Group #{resource_group_name}."
          Fog::Logger.debug msg
          begin
            network_gateway = @network_client.virtual_network_gateways.get(resource_group_name, network_gateway_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Virtual Network Gateway #{network_gateway_name} retrieved successfully."
          network_gateway
        end
      end

      # Mock class for Network Gateway Request
      class Mock
        def get_virtual_network_gateway(*)
          gateway = {
            'name' => 'myvirtualgateway1',
            'id' => '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/microsoft.network/virtualNetworkGateways/myvirtualgateway1',
            'location' => 'West US',
            'tags' => { 'key1' => 'value1' },
            'properties' => {
              'gatewayType' => 'DynamicRouting',
              'gatewaySize' => 'Default',
              'subnet' => {
                'id' => '/subscriptions/<subscriptionId>/resourceGroups/<resourceGroupName>/providers/microsoft.network/virtualNetworks/<virtualNetworkName>/subnets/subnet1'
              },
              'vipAddress' => '{vipAddress}',
              'bgpEnabled' => true,
              'vpnClientAddressPool' => ['{vpnClientAddressPoolPrefix}'],
              'defaultSites' => ['mysite1']
            }
          }
          gateway_mapper = Azure::Network::Profiles::Latest::Mgmt::Models::VirtualNetworkGateway.mapper
          @network_client.deserialize(gateway_mapper, gateway, 'result.body')
        end
      end
    end
  end
end
