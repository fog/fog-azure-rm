module Fog
  module Network
    class AzureRM
      class Real
        def list_public_ips(resource_group)
          puts "Getting list of PublicIPs from Resource Group #{resource_group}."
          begin
            promise = @network_client.public_ipaddresses.list(resource_group)
            response = promise.value!
            result = response.body.value
            return result
          rescue  MsRestAzure::AzureOperationError =>e
            msg = "Error Getting list of PublicIPs from ResourceGroup '#{resource_group}'"
            fail msg
          end
        end
      end

      class Mock
        def list_public_ips(resource_group)

        end
      end
    end
  end
end