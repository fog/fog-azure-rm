module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def list_express_route_service_providers
          msg = 'Getting list of Express Route Service Providers.'
          Fog::Logger.debug msg
          begin
            service_providers = @network_client.express_route_service_providers.list
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          service_providers
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
