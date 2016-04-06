module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def create_public_ip(resource_group, name, public_ip)
          puts "Creating PublicIP #{name} in Resource Group #{resource_group}."
          begin
            promise = @network_client.public_ipaddresses.create_or_update(resource_group, name, public_ip)
            response = promise.value!
            result = response.body
            puts "PublicIP #{name} Created Successfully!"
            return result
          rescue MsRestAzure::AzureOperationError => ex
            msg = "Exception trying to create/update public ip #{public_ip.name} from resource group: #{resource_group}. #{ex.body}"
            fail msg
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def create_public_ip(resource_group, name, public_ip)
        end
      end
    end
  end
end
