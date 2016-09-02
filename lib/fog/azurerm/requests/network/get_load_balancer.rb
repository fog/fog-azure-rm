module Fog
  module Network
    class AzureRM
      # Real class for Load-Balancer Request
      class Real
        def get_load_balancer(resource_group_name, load_balancer_name)
          msg = "Getting Load-Balancer: #{load_balancer_name} in Resource Group: #{resource_group_name}"
          Fog::Logger.debug msg
          begin
            load_balancer = @network_client.load_balancers.get(resource_group_name, load_balancer_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          load_balancer
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
