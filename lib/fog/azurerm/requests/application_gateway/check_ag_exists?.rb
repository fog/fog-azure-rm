module Fog
  module ApplicationGateway
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def check_ag_exists?(resource_group_name, application_gateway_name)
          msg = "Checking Application Gateway: #{application_gateway_name}"
          Fog::Logger.debug msg
          begin
            @network_client.application_gateways.get(resource_group_name, application_gateway_name)
            Fog::Logger.debug "Application Gateway #{application_gateway_name} exists."
            true
          rescue MsRestAzure::AzureOperationError => e
            if e.body['error']['code'] == 'ResourceNotFound'
              Fog::Logger.debug "Application Gateway #{application_gateway_name} doesn't exist."
              false
            else
              raise_azure_exception(e, msg)
            end
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def check_ag_exists?(*)
          true
        end
      end
    end
  end
end
