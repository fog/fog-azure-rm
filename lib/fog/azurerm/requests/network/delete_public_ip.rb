module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def delete_public_ip(resource_group, name)
          Fog::Logger.debug "Deleting PublicIP #{name} from Resource Group #{resource_group}."
          begin
            promise = @network_client.public_ipaddresses.delete(resource_group, name)
            promise.value!
            Fog::Logger.debug "PublicIP #{name} Deleted Successfully."
            true
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Exception deleting Public IP #{name} in Resource Group: #{resource_group}. #{e.body['error']['message']}"
            raise msg
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def delete_public_ip(resource_group, name)
          Fog::Logger.debug "Public IP #{name} from Resource group #{resource_group} deleted successfully."
          return true
        end
      end
    end
  end
end
