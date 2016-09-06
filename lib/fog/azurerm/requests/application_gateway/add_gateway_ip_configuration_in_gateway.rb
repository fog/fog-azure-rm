module Fog
  module ApplicationGateway
    class AzureRM
      # Real class for Application Gateway Request
      class Real
        def add_gateway_ip_configuration_in_gateway(resource_group, name, gateway_ip_configuration_hash)
          msg = "Creating Application Gateway: #{name} in Resource Group: #{resource_group}."
          Fog::Logger.debug msg
          gateway = define_application_gateway(gateway_params)
          begin
            gateway_obj = @network_client.application_gateways.create_or_update(gateway_params[:resource_group], gateway_params[:name], gateway)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Application Gateway #{gateway_params[:name]} created successfully."
          gateway_obj
        end
      end

      # Mock class for Network Request
      class Mock
        def create_application_gateway(_name, _location, _resource_group, _sku_name, _sku_tier, _sku_capacity, _gateway_ip_configurations, _ssl_certificates, _frontend_ip_configurations, _frontend_ports, _probes, _backend_address_pools, _backend_http_settings_list, _http_listeners, _url_path_maps, _request_routing_rules)
        end
      end
    end
  end
end
