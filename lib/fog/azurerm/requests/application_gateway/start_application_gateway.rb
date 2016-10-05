module Fog
  module ApplicationGateway
    class AzureRM
      class Real
        def start_application_gateway(resource_group, name)
          msg = "Starting Application Gateway #{name} in Resource Group #{resource_group}"
          Fog::Logger.debug msg

          begin
            @network_client.application_gateways.start(resource_group, name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Successfully started Application Gateway #{name} in Resource Group #{resource_group}"
          true
        end
      end

      class Mock
        def start_application_gateway(*)
          Fog::Logger.debug 'Successfully started Application Gateway {name} in Resource Group {resource_group}'
          true
        end
      end
    end
  end
end