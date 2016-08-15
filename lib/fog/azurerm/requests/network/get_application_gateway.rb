module Fog
  module Network
    class AzureRM
      # Real class for Application Gateway Request
      class Real
        def get_application_gateway(resource_group_name, application_gateway_name)
          Fog::Logger.debug "Getting Application Gateway: #{application_gateway_name} in Resource group: #{resource_group_name}"
          begin
            promise = @network_client.application_gateways.get(resource_group_name, application_gateway_name)
            result = promise.value!
            Azure::ARM::Network::Models::ApplicationGateway.serialize_object(result.body)
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception getting Application Gateway #{application_gateway_name} in Resource Group: #{resource_group_name}. #{e.body['error']['message']}"
            raise msg
          end
        end
      end

      # Mock class for Application Gateway Request
      class Mock

      end
    end
  end
end
