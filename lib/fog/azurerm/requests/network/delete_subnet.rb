module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def delete_subnet(resource_group, name, virtual_network_name)
          Fog::Logger.debug "Deleting Subnet: #{name}..."
          begin
            promise = @network_client.subnets.delete(resource_group, virtual_network_name, name)
            promise.value!
            Fog::Logger.debug "Subnet #{name} deleted successfully."
            true
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception deleting Subnet #{name} in Resource Group: #{resource_group}. #{e.body['error']['message']}"
            raise msg
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def delete_subnet(_resource_group, _name, _virtual_network_name)
        end
      end
    end
  end
end
