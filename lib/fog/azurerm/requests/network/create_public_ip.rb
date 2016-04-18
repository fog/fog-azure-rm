module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def create_public_ip(resource_group, name, public_ip)
          Fog::Logger.debug "Creating PublicIP #{name} in Resource Group #{resource_group}."
          begin
            promise = @network_client.public_ipaddresses.create_or_update(resource_group, name, public_ip)
            response = promise.value!
            result = response.body
            Fog::Logger.debug "PublicIP #{name} Created Successfully!"
            return result
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception creating Public IP #{name} in Resource Group: #{resource_group}. #{e.body['error']['message']}"
            raise msg
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
