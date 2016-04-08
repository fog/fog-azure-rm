module Fog
  module Network
    class AzureRM
      class Real
        def check_for_virtual_network(name, resource_group)
          begin
            promise = @network_client.virtual_networks.get(resource_group, name)
            promise.value!
            return true
          rescue MsRestAzure::AzureOperationError => e
            if e.body['error']['code'] == 'ResourceNotFound'
              false
            elsif e.body == ''
              true
            else
              msg = "Exception checking name availability: #{e.body['error']['message']}"
              fail msg
            end
          end
        end
      end

      class Mock
        def check_for_virtual_network(_name, _resource_group)
        end
      end
    end
  end
end
