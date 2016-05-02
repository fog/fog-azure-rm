module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def delete_subnet(resource_group, virtual_network_name, subnet_name)
          Fog::Logger.debug "Deleting Subnet: #{subnet_name}..."
          begin
            promise = @network_client.subnets.delete(resource_group, virtual_network_name, subnet_name)
            response = promise.value!
            Fog::Logger.debug "Subnet #{subnet_name} deleted successfully."
            response
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception deleting Subnet #{subnet_name} in Resource Group: #{resource_group}. #{e.body['error']['message']}"
            raise msg
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def delete_subnet(_resource_group, _virtual_network_name, _subnet_name)
        end
      end
    end
  end
end
