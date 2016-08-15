module Fog
  module Network
    class AzureRM
      # Real class for Traffic Manager Endpoint Request
      class Real
        def get_traffic_manager_endpoint(resource_group_name, endpoint_name, traffic_manager_profile_name, endpoint_type)
          Fog::Logger.debug "Getting Traffic Manager Endpoint: #{endpoint_name}..."
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group_name}/providers/Microsoft.Network/trafficManagerProfiles/#{traffic_manager_profile_name}/#{endpoint_type}Endpoints/#{endpoint_name}?api-version=2015-11-01"
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            response = RestClient.get(
                resource_url,
                accept: :json,
                content_type: :json,
                authorization: token
            )
            JSON.parse(response)
          rescue => e
            Fog::Logger.warning "Exception creating Traffic Manager Endpoint: #{name} in resource group #{resource_group}"
            error_msg = JSON.parse(e.response)['message']
            msg = "Exception creating Traffic Manager Endpoint: #{name} in resource group #{resource_group}. #{error_msg}"
            raise msg
          end
        end
      end
      class Mock

      end
    end
  end
end
