module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def delete_traffic_manager_profile(resource_group, name)
          Fog::Logger.debug "Deleting Traffic Manager Profile: #{name}..."
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.Network/trafficManagerProfiles/#{name}?api-version=2015-04-28-preview"
          begin
            token = Fog::Credentials::AzureRM.get_token(@tenant_id, @client_id, @client_secret)
            RestClient.delete(
              resource_url,
              accept: :json,
              content_type: :json,
              authorization: token
            )
            Fog::Logger.debug "Traffic Manager Profile: #{name} deleted successfully."
            true
          rescue => e
            Fog::Logger.warning "Exception deleting Traffic Manager Profile: #{name} in resource group #{resource_group}"
            error_msg = JSON.parse(e.response)['message']
            msg = "Exception deleting Traffic Manager Profile: #{name} in resource group #{resource_group}. #{error_msg}"
            raise msg
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def delete_subnet(resource_group, name)
          Fog::Logger.debug "Traffic Manager Profile #{name} from Resource group #{resource_group} deleted successfully."
          true
        end
      end
    end
  end
end
