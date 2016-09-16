module Fog
  module ApplicationGateway
    class AzureRM
      # Real class for Application Gateway Request
      class Real
        def update_sku_attributes(gateway_params, sku_name, sku_capacity)
          msg = "Updating sku attributes for #{sku_name}"
          Fog::Logger.debug msg
          gateway_params[:sku_name] = sku_name if sku_name
          gateway_params[:sku_capacity] = sku_capacity if sku_capacity
          begin
            gateway = create_or_update_application_gateway(gateway_params)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Sku #{sku_name} updated Successfully"
          gateway
        end
      end

      # Mock class for Application Gateway Request
      class Mock
        def update_sku_attributes(*)
        end
      end
    end
  end
end
