module Fog
  module ApplicationGateway
    class AzureRM
      # Real class for Application Gateway Request
      class Real
        def get_application_gateway(resource_group_name, application_gateway_name)
          msg = "Getting Application Gateway: #{application_gateway_name} in Resource group: #{resource_group_name}"
          Fog::Logger.debug msg
          begin
            application_gateway = @network_client.application_gateways.get(resource_group_name, application_gateway_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Getting application gateway #{application_gateway_name} successfully in Resource Group: #{resource_group_name}"
          application_gateway
        end
      end

      # Mock class for Application Gateway Request
      class Mock
        def get_application_gateway(*)
        end
      end
    end
  end
end
