module Fog
  module Compute
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def get_virtual_machine(resource_group, name)
          begin
            promise = @compute_mgmt_client.virtual_machines.get(resource_group, name)
            response = promise.value!
            response.body
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception getting Virtual Machine #{name} from Resource Group '#{resource_group}'. #{e.body['error']['message']}"
            raise msg
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def get_virtual_machine(resource_group, name)
        end
      end
    end
  end
end
