module Fog
  module ApplicationGateway
    class AzureRM
      # Real class for Network Request
      class Real
        def delete_application_gateway(resource_group, name)
          logger_msg = "Deleting Application_Gateway #{name} from Resource Group #{resource_group}."
          Fog::Logger.debug logger_msg
          begin
            promise = @network_client.application_gateways.delete(resource_group, name)
            promise.value!
            Fog::Logger.debug "Application Gateway #{name} Deleted Successfully."
            true
          rescue  MsRestAzure::AzureOperationError => e
            raise generate_exception_message(logger_msg, e)
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def delete_application_gateway(_resource_group, _name)
        end
      end
    end
  end
end
