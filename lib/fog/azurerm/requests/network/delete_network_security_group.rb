module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def delete_network_security_group(resource_group, name)
          Fog::Logger.debug "Deleting Network Security Group: #{name}..."
          begin
            promise = @network_client.network_security_groups.delete(resource_group, name)
            promise.value!
            Fog::Logger.debug "Network Security Group #{name} deleted successfully."
            true
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception deleting Network Security Group #{name} in Resource Group: #{resource_group}. #{e.body['error']['message']}"
            raise msg
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def delete_network_security_group(resource_group, name)
          Fog::Logger.debug "Network Security Group #{name} from Resource group #{resource_group} deleted successfully."
          true
        end
      end
    end
  end
end
