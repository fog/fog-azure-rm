module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def delete_virtual_network(resource_group_name, name)
          begin
            promise = @network_client.virtual_networks.delete(resource_group_name, name)
            promise.value!
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception deleting Virtual Netwrok: #{e.body['error']['message']}"
            fail msg
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def delete_virtual_network(_resource_group_name, _name)
        end
      end
    end
  end
end
