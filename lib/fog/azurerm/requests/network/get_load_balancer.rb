module Fog
  module Network
    class AzureRM
      # Real class for Load-Balancer Request
      class Real
        def get_load_balancer(resource_group_name, load_balancer_name)
          Fog::Logger.debug "Getting Load-Balancer: #{load_balancer_name} in Resource Group: #{resource_group_name}"
          begin
            promise = @network_client.load_balancers.get(resource_group_name, load_balancer_name)
            result = promise.value!
            Azure::ARM::Network::Models::LoadBalancer.serialize_object(result.body)
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception getting Load-Balancer #{load_balancer_name} in Resource Group: #{resource_group_name}. #{e.body['error']['message']}"
            raise msg
          end
        end

        # Mock class for Load-Balancer Request
        class Mock
          def get_load_balancer(*)

          end
        end
      end
    end
  end
end
