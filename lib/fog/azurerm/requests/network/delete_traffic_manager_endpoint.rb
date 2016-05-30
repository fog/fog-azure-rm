module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def delete_traffic_manager_endpoint(resource_group, name, traffic_manager_profile_name, type)
          Fog::Logger.debug "Deleting Traffic Manager Endpoint: #{name}..."
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.Network/trafficManagerProfiles/#{traffic_manager_profile_name}/#{type}Endpoints/#{name}?api-version=2015-11-01"
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            RestClient.delete(
              resource_url,
              accept: :json,
              content_type: :json,
              authorization: token
            )
            Fog::Logger.debug "Traffic Manager Endpoint: #{name} deleted successfully."
            true
          rescue => e
            Fog::Logger.warning "Exception deleting Traffic Manager Endpoint: #{name} in resource group #{resource_group}"
            error_msg = JSON.parse(e.response)['message']
            msg = "Exception deleting Traffic Manager Endpoint: #{name} in resource group #{resource_group}. #{error_msg}"
            raise msg
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def delete_traffic_manager_endpoint(_resource_group, _name, _traffic_manager_profile_name, _type)
          true
        end
      end
    end
  end
end
