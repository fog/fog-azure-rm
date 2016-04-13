module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def delete_network_interface(resource_group, name)
          puts "Deleting NetworkInterface #{name} from Resource Group #{resource_group}."
          begin
            promise = @network_client.network_interfaces.delete(resource_group, name)
            response = promise.value!
            result = response.body
            puts "NetworkInterface #{name} Deleted Successfully."
            return result
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Error Deleting NetworkInterface '#{name}' from ResourceGroup '#{resource_group}'. #{e.body.error.message}."
            fail msg
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def delete_network_interface(_resource_group, _name)
        end
      end
    end
  end
end
