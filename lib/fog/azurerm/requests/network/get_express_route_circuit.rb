module Fog
  module Network
    class AzureRM
      # Real class for Express Route Circuit Request
      class Real
        def get_express_route_circuit(resource_group_name, circuit_name)
          Fog::Logger.debug "Getting Express Route Circuit#{circuit_name} from Resource Group #{resource_group_name}."
          begin
            promise = @network_client.express_route_circuits.get(resource_group_name, circuit_name)
            result = promise.value!
            Azure::ARM::Network::Models::ExpressRouteCircuit.serialize_object(result.body)
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception getting Express Route Circuit #{circuit_name} from Resource Group '#{resource_group_name}'. #{e.body['error']['message']}."
            raise msg
          end
        end
      end

      # Mock class for Express Route Circuit Request
      class Mock
        def get_express_route_circuit(*)
          {
            'name' => 'circuit_name',
            'id' => '/subscriptions/{subscriptionId}/resourceGroup/{resource_group_name}/providers/Microsoft.Network/expressRouteCircuits/{circuit_name}',
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
        end
      end
    end
  end
end
