module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def delete_public_ip(resource_group, name)
          Fog::Logger.debug "Deleting PublicIP #{name} from Resource Group #{resource_group}."
          begin
            promise = @network_client.public_ipaddresses.delete(resource_group, name)
            response = promise.value!
            result = response.body
            Fog::Logger.debug "PublicIP #{name} Deleted Successfully."
            return result
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Error Deleting PublicIP '#{name}' from ResourceGroup '#{resource_group}'. #{e.body}"
            fail msg
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def delete_public_ip(_resource_group, _name)
        end
      end
    end
  end
end
