module Fog
  module Network
    class AzureRM
      # Real class for Express Route Circuit Authorization Request
      class Real
        def create_or_update_express_route_circuit_authorization(circuit_authorization_params)
          msg = @logger_messages['network']['express_route_circuit_authentication']['message']['create']
                .gsub('NAME', circuit_authorization_params[:authorization_name])
                .gsub('RESOURCE_GROUP', circuit_authorization_params[:resource_group])
          Fog::Logger.debug msg
          circuit_authorization = get_circuit_authorization_object(circuit_authorization_params)
          begin
            authorization = @network_client.express_route_circuit_authorizations.create_or_update(circuit_authorization_params[:resource_group], circuit_authorization_params[:circuit_name], circuit_authorization_params[:authorization_name], circuit_authorization)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Express Route Circuit Authorization #{circuit_authorization_params[:authorization_name]} created/updated successfully."
          authorization
        end

        private

        def get_circuit_authorization_object(circuit_authorization_params)
          circuit_authorization = Azure::Network::Profiles::Latest::Mgmt::Models::ExpressRouteCircuitAuthorization.new
          circuit_authorization.name = circuit_authorization_params[:authorization_name]
          circuit_authorization.authorization_key = circuit_authorization_params[:authorization_key]
          circuit_authorization.authorization_use_status = circuit_authorization_params[:authorization_use_status]
          circuit_authorization.provisioning_state = circuit_authorization_params[:provisioning_state]
          circuit_authorization.etag = circuit_authorization_params[:etag]

          circuit_authorization
        end
      end

      # Mock class for Express Route Circuit Authorization Request
      class Mock
        def create_or_update_express_route_circuit_authorization(*)
          authorization = {
            'name' => 'authorization-name',
            'properties' => {
              'authorizationKey' => 'authorization-key',
              'authorizationUseStatus' => 'Available'
            }
          }
          authorization_mapper = Azure::Network::Profiles::Latest::Mgmt::Models::ExpressRouteCircuitAuthorization.mapper
          @network_client.deserialize(authorization_mapper, authorization, 'result.body')
        end
      end
    end
  end
end
