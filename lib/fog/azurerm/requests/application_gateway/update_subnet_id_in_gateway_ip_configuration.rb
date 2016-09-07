module Fog
  module ApplicationGateway
    class AzureRM
      # Real class for Application Gateway Request
      class Real
        def update_subnet_id_in_gateway_ip_configuration(gateway_params, subnet_id)
          msg = "Updating Subnet id of IP Configuration"
          Fog::Logger.debug msg
          gateway_params[:gateway_ip_configurations].each do |ip_configuration|
            ip_configuration[:subnet_id] = subnet_id
          end
          begin
            gateway = create_application_gateway(gateway_params)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Updated Successfully"
          gateway
        end
      end

      # Mock class for Application Gateway Request
      class Mock
        def update_subnet_id_in_gateway_ip_configuration(gateway_params, subnet_id)
        end
      end
    end
  end
end
