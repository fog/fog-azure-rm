module Fog
  module Compute
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def list_available_sizes_for_virtual_machine(resource_group, name)
          begin
            response = @compute_mgmt_client.virtual_machines.list_available_sizes(resource_group, name)
            result = response.value!
            result.body.value
          rescue MsRestAzure::AzureOperationError => e
            msg = "Error listing Sizes for Virtual Machine #{name} in Resource Group '#{resource_group}'. #{e.body['error']['message']}"
            raise msg
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def list_available_sizes_for_virtual_machine(resource_group, name)
        end
      end
    end
  end
end
