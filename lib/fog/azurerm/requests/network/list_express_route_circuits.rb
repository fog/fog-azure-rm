module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def list_express_route_circuits(resource_group_name)
          msg = "Getting list of Express Route Circuits from Resource Group #{resource_group_name}."
          Fog::Logger.debug msg
          begin
            circuits = @network_client.express_route_circuits.list(resource_group_name).value!
            Azure::ARM::Network::Models::ExpressRouteCircuitListResult.serialize_object(circuits.body)['value']
          rescue  MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def list_express_route_circuits(*)
          [
            {
              'name' => 'testCircuit',
              'id' => '/subscriptions/########-####-####-####-############/resourceGroup/resource_group_name/providers/Microsoft.Network/expressRouteCircuits/circuitName',
              'etag' => 'W/\"00000000-0000-0000-0000-000000000000\"',
              'location' => 'eastus',
              'tags' => {
                'key1' => 'value1',
                'key2' => 'value2'
              },
              'sku' => {
                'name' => 'Standard_MeteredData',
                'tier' => 'Standard',
                'family' => 'MeteredData'
              },
              'properties' => {
                'provisioningState' => 'Succeeded',
                'circuitProvisioningState' => 'Enabled',
                'serviceProviderProvisioningState' => 'Provisioned',
                'serviceProviderProperties' => {
                  'serviceProviderName' => 'Telenor',
                  'peeringLocation' => 'London',
                  'bandwidthInMbps' => 100
                }
              },
              'serviceKey' => '<unique service key for circuit>',
              'serviceProviderNotes' => '<notes set only by ServiceProvider>'
            }
          ]
        end
      end
    end
  end
end
