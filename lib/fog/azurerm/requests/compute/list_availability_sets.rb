# rubocop:disable LineLength
module Fog
  module Compute
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def list_availability_sets(resource_group)
          response = @compute_mgmt_client.availability_sets.list(resource_group)
          result = response.value!
          result.body.value
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def list_availability_sets(resource_group)
        end
      end
    end
  end
end
