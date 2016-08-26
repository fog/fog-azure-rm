module Fog
  module Network
    class AzureRM
      # Real class for Express Route Circuit Peering Request
      class Real
        def get_express_route_circuit_peering(resource_group_name, peering_name, circuit_name)
          msg = "Getting Express Route Circuit Peering #{peering_name} from Resource Group #{resource_group_name}."
          Fog::Logger.debug msg
          begin
            circuit_peering = @network_client.express_route_circuit_peerings.get(resource_group_name, circuit_name, peering_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          circuit_peering
        end
      end

      # Mock class for Express Route Circuit Peering Request
      class Mock
        def get_express_route_circuit_peering(*)
          {
            'name' => 'peering_name',
            'id' => '/subscriptions/########-####-####-####-############/resourceGroups/resource_group_name/providers/Microsoft.Network/expressRouteCircuits/circuit_name/peerings/peering_name',
            'etag' => '',
            'properties' => {
              'provisioningState' => 'Succeeded',
              'peeringType' => 'MicrosoftPeering',
              'peerASN' => '',
              'primaryPeerAddressPrefix' => '',
              'secondaryPeerAddressPrefix' => '',
              'primaryAzurePort' => 22,
              'secondaryAzurePort' => 21,
              'state' => 'Enabled',
              'sharedKey' => '',
              'vlanId' => 100,
              'microsoftPeeringConfig' => {
                'advertisedpublicprefixes' => %w(prefix1 prefix2),
                'advertisedPublicPrefixState' => 'ValidationNeeded',
                'customerAsn' => '',
                'routingRegistryName' => ''
              }
            }
          }
        end
      end
    end
  end
end
