module Fog
  module Compute
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def list_virtual_machines(resource_group)
          begin
            response = @compute_mgmt_client.virtual_machines.list(resource_group)
            result = response.value!
            result.body.value
          rescue MsRestAzure::AzureOperationError => e
            msg = "Error listing Virtual Machines in Resource Group '#{resource_group}'. #{e.body['error']['message']}"
            raise msg
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def list_virtual_machines(resource_group)
        end
      end
    end
  end
end
