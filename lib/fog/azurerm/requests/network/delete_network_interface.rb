module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def delete_network_interface(resource_group, name)
          Fog::Logger.debug "Deleting NetworkInterface #{name} from Resource Group #{resource_group}."
          begin
            promise = @network_client.network_interfaces.delete(resource_group, name)
            promise.value!
            Fog::Logger.debug "NetworkInterface #{name} Deleted Successfully."
            true
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Exception deleting Network Interface #{name} in Resource Group: #{resource_group}. #{e.body['error']['message']}"
            raise msg
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def delete_network_interface(_resource_group, _name)
          Fog::Logger.debug "Network Interface #{_name} from Resource group #{_resource_group} deleted successfully."
          return true
        end
      end
    end
  end
end
