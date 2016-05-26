module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def delete_load_balancer(resource_group, name)
          Fog::Logger.debug "Deleting Load_Balancer #{name} from Resource Group #{resource_group}."
          begin
            promise = @network_client.load_balancers.delete(resource_group, name)
            promise.value!
            Fog::Logger.debug "Load_Balancer #{name} Deleted Successfully."
            true
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Exception deleting Load_Balancer #{name} in Resource Group: #{resource_group}. #{e.body['error']['message']}"
            raise msg
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def delete_load_balancer(_resource_group, _name)
        end
      end
    end
  end
end
