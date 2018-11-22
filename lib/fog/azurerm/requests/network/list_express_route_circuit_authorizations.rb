module Fog
  module Network
    class AzureRM
      # Real class for Express Route Circuit Authorization Request
      class Real
        def list_express_route_circuit_authorizations(resource_group_name, circuit_name)
          msg = @logger_messages['network']['express_route_circuit_authentication']['message']['list']
                .gsub('RESOURCE_GROUP', resource_group_name)
          Fog::Logger.debug msg
          begin
            circuit_authorizations = @network_client.express_route_circuit_authorizations.list(resource_group_name, circuit_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          circuit_authorizations
        end
      end

      # Mock class for Express Route Circuit Authorization Request
      class Mock
        def list_express_route_circuit_authorizations(*)
          authorizations = [
            {
              'name' => 'authorization-name',
              'properties' => {
                'authorizationKey' => 'authorization-key',
                'authorizationUseStatus' => 'Available'
              }
            }
          ]
          authorization_mapper = Azure::Network::Profiles::Latest::Mgmt::Models::ExpressRouteCircuitAuthorization.mapper
          @network_client.deserialize(authorization_mapper, authorizations, 'result.body')
        end
      end
    end
  end
end
