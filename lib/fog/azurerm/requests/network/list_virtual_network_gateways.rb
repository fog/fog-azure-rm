module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def list_virtual_network_gateways(resource_group)
          msg = "Getting list of Virtual Network Gateway from Resource Group #{resource_group}."
          Fog::Logger.debug msg
          begin
            network_gateways = @network_client.virtual_network_gateways.list_as_lazy(resource_group)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          network_gateways.value
        end
      end

      # Mock class for Network Request
      class Mock
        def list_virtual_network_gateways(*)
          gateway = {
            'value' => [
              {
                'name' => 'myvirtualgateway1',
                'location' => 'West US',
                'tags' => { 'key1' => 'value1' },
                'properties' => {
                  'gatewayType' => 'DynamicRouting',
                  'gatewaySize' => 'Default',
                  'bgpEnabled' => true,
                  'vpnClientAddressPool' => ['{vpnClientAddressPoolPrefix}'],
                  'defaultSites' => ['mysite1']
                }
              }
            ]
          }
          gateway_mapper = Azure::Network::Profiles::Latest::Mgmt::Models::VirtualNetworkGatewayListResult.mapper
          @network_client.deserialize(gateway_mapper, gateway, 'result.body').value
        end
      end
    end
  end
end
