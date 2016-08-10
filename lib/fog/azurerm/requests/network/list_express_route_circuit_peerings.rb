module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def list_express_route_circuit_peerings(resource_group_name, circuit_name)
          Fog::Logger.debug "Getting list of Express Route Circuit Peerings from Resource Group #{resource_group_name}."
          begin
            promise = @network_client.express_route_circuit_peerings.list(resource_group_name, circuit_name)
            result = promise.value!
            Azure::ARM::Network::Models::ExpressRouteCircuitPeeringListResult.serialize_object(result.body)['value']
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Exception listing Express Route Circuit Peerings from Resource Group '#{resource_group_name}'. #{e.body['error']['message']}."
            raise msg
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def list_express_route_circuit_peerings(*)
          [
            {
              'name' => 'AzurePrivatePeering',
              'id' => '/subscriptions/a932c0e6-b5cb-4e68-b23d-5064372c8a3c/resourceGroups/#{resource_group_name}/providers/Microsoft.Network/expressRouteCircuits/#{circuit_name}/peerings/Private',
              'etag' => 'W/\"cb87537e-fd92-48c7-905f-2efc95a47c8f\"',
              'properties' => {
                'provisioningState' => 'Succeeded',
                'peeringType' => 'AzurePrivatePeering',
                'azureASN' => 120,
                'peerASN' => 100,
                'primaryPeerAddressPrefix' => '192.168.1.0/30',
                'secondaryPeerAddressPrefix' => '192.168.2.0/30',
                'primaryAzurePort' => 'BRKAZUREIXP01-BN1-04GMR-CIS-1-PRIMARY',
                'secondaryAzurePort' => 'BRKAZUREIXP01-DM2-04GMR-CIS-1-SECONDARY',
                'state' => 'Enabled',
                'vlanId' => 200
              }
            }
          ]
        end
      end
    end
  end
end
