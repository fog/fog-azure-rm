module Fog
  module Network
    class AzureRM
      class Real
        def delete_public_ip(resource_group, name)
          puts "Deleting PublicIP #{name} from Resource Group #{resource_group}."
          begin
            promise = @network_client.public_ipaddresses.delete(resource_group, name)
            response = promise.value!
            result = response.body
            puts "PublicIP #{name} Deleted Successfully."
            return result
          rescue  MsRestAzure::AzureOperationError =>e
            msg = "Error Deleting PublicIP '#{name}' from ResourceGroup '#{resource_group}'"
            fail msg
          end
        end
      end

      class Mock
        def delete_public_ip(resource_group, name)

        end
      end
    end
  end
end