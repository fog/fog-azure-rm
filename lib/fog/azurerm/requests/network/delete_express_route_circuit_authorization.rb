module Fog
  module Network
    class AzureRM
      # Real class for Express Route Circuit Authorization Request
      class Real
        def delete_express_route_circuit_authorization(resource_group_name, circuit_name, authorization_name)
          msg = @logger_messages['network']['express_route_circuit_authentication']['message']['delete']
                .gsub('NAME', authorization_name).gsub('RESOURCE_GROUP', resource_group_name)
          Fog::Logger.debug msg
          begin
            @network_client.express_route_circuit_authorizations.delete(resource_group_name, circuit_name, authorization_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Express Route Circuit Authorization #{authorization_name} Deleted Successfully."
          true
        end
      end

      # Mock class for Express Route Circuit Authorization Request
      class Mock
        def delete_express_route_circuit_authorization(*)
          Fog::Logger.debug 'Express Route Circuit Authorization {authorization_name} from Resource group {resource_group_name} deleted successfully.'
          true
        end
      end
    end
  end
end
