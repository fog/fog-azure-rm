module Fog
  module ApplicationGateway
    class AzureRM
      # Real class for Application Gateway Request
      class Real
        def delete_application_gateway(resource_group, name)
          msg = "Deleting Application_Gateway #{name} from Resource Group #{resource_group}."
          Fog::Logger.debug msg
          begin
            @network_client.application_gateways.delete(resource_group, name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Application Gateway #{name} Deleted Successfully."
          true
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
