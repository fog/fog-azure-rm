module Fog
  module ApplicationGateway
    class AzureRM
      # Real class for Network Request
      class Real
        def list_application_gateways(resource_group)
          logger_msg = "Getting list of Application-Gateway from Resource Group #{resource_group}."
          Fog::Logger.debug logger_msg
          begin
            promise = @network_client.application_gateways.list(resource_group)
            result = promise.value!
            Azure::ARM::Network::Models::ApplicationGatewayListResult.serialize_object(result.body)['value']
          rescue MsRestAzure::AzureOperationError => e
            raise generate_exception_message(logger_msg, e)
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def list_application_gateways(_resource_group)
          ag = Azure::ARM::Network::Models::ApplicationGateway.new
          ag.name = 'fogtestgateway'
          ag.location = 'East US'
          ag.properties = Azure::ARM::Network::Models::ApplicationGatewayPropertiesFormat.new
          [ag]
        end
      end
    end
  end
end
