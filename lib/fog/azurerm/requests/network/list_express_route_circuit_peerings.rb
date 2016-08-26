module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def list_express_route_circuit_peerings(resource_group_name, circuit_name)
          msg = "Getting list of Express Route Circuit Peerings from Resource Group #{resource_group_name}."
          Fog::Logger.debug msg
          begin
            circuit_peerings = @network_client.express_route_circuit_peerings.list(resource_group_name, circuit_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          circuit_peerings
        end
      end

      # Mock class for Network Request
      class Mock
        def list_express_route_circuit_peerings(*)
          [
            {
              'name' => 'AzurePrivatePeering',
              'id' => '/subscriptions/########-####-####-####-############/resourceGroups/resource_group_name/providers/Microsoft.Network/expressRouteCircuits/circuit_name/peerings/Private',
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
