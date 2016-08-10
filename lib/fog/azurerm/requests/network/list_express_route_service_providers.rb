module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def list_express_route_service_providers
          Fog::Logger.debug 'Getting list of Express Route Service Providers.'
          begin
            promise = @network_client.express_route_service_providers.list
            result = promise.value!
            Azure::ARM::Network::Models::ExpressRouteServiceProviderListResult.serialize_object(result.body)['value']
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Exception listing Express Route Service Providers. #{e.body['error']['message']}."
            raise msg
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def list_express_route_service_providers
          [
            {
              'name' => 'Telenor',
              'peeringLocations' => %w(London Karachi),
              'bandwidthsOffered' => [
                {
                  'offerName' => '100Mbps',
                  'valueInMbps' => 100
                }
              ]
            }
          ]
        end
      end
    end
  end
end
