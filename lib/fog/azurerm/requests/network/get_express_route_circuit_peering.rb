module Fog
  module Network
    class AzureRM
      # Real class for Express Route Circuit Peering Request
      class Real
        def get_express_route_circuit_peering(resource_group_name, peering_name, circuit_name)
          Fog::Logger.debug "Getting Express Route Circuit Peering #{peering_name} from Resource Group #{resource_group_name}."
          begin
            promise = @network_client.express_route_circuit_peerings.get(resource_group_name, circuit_name, peering_name)
            result = promise.value!
            Azure::ARM::Network::Models::ExpressRouteCircuitPeering.serialize_object(result.body)
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception getting Express Route Circuit Peering #{peering_name} from Resource Group '#{resource_group_name}'. #{e.body['error']['message']}."
            raise msg
          end
        end
      end

      # Mock class for Express Route Circuit Peering Request
      class Mock
        def get_express_route_circuit_peering(*)
          {
            'name' => 'peering_name',
            'id' => '/subscriptions/{subscriptionId}/resourceGroups/{resource_group_name}providers/Microsoft.Network/expressRouteCircuits/{circuit_name}/peerings/{peering name}',
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
