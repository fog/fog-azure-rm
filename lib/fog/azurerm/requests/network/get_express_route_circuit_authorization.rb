module Fog
  module Network
    class AzureRM
      # Real class for Express Route Circuit Authorization Request
      class Real
        def get_express_route_circuit_authorization(resource_group_name, circuit_name, authorization_name)
          msg = "Getting Express Route Circuit Authorization #{authorization_name} from Resource Group #{resource_group_name}."
          Fog::Logger.debug msg
          begin
            circuit_authorization = @network_client.express_route_circuit_authorizations.get(resource_group_name, circuit_name, authorization_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          circuit_authorization
        end
      end

      # Mock class for Express Route Circuit Authorization Request
      class Mock
        def get_express_route_circuit_authorization(*)
          authorization = {
            'name' => 'authorization-name',
            'properties' => {
              'authorizationKey' => 'authorization-key',
              'authorizationUseStatus' => 'Available'
            }
          }
          authorization_mapper = Azure::ARM::Network::Models::ExpressRouteCircuitAuthorization.mapper
          @network_client.deserialize(authorization_mapper, authorization, 'result.body')
        end
      end
    end
  end
end
