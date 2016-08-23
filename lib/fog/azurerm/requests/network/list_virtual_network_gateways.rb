module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def list_virtual_network_gateways(resource_group)
          msg = "Getting list of Virtual Network Gateway from Resource Group #{resource_group}."
          Fog::Logger.debug msg
          begin
            network_gateway = @network_client.virtual_network_gateways.list(resource_group).value!
            Azure::ARM::Network::Models::VirtualNetworkGatewayListResult.serialize_object(network_gateway.body)['value']
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def list_virtual_network_gateways(*)
          [
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
        end
      end
    end
  end
end
