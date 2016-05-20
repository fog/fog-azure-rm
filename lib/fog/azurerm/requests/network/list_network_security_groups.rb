module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def list_network_security_groups(resource_group)
          Fog::Logger.debug "Getting list of Network Security Groups from Resource Group #{resource_group}."
          begin
            promise = @network_client.network_security_groups.list(resource_group)
            result = promise.value!
            Azure::ARM::Network::Models::NetworkSecurityGroupListResult.serialize_object(result.body)['value']
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception listing Network Security Groups from Resource Group '#{resource_group}'. #{e.body['error']['message']}."
            raise msg
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def list_network_security_groups(_resource_group)
        end
      end
    end
  end
end
