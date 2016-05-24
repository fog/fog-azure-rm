module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def delete_virtual_network(resource_group, name)
          Fog::Logger.debug "Deleting Virtual Network: #{name}..."
          begin
            promise = @network_client.virtual_networks.delete(resource_group, name)
            promise.value!
            Fog::Logger.debug "Virtual Network #{name} deleted successfully."
            true
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception deleting Virtual Network #{name} in Resource Group: #{resource_group}. #{e.body['error']['message']}"
            raise msg
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def delete_virtual_network(_resource_group, _name)
        end
      end
    end
  end
end
