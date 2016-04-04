# rubocop:disable LineLength
module Fog
  module Compute
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def create_availability_set(resource_group_name, name, params)
          @compute_mgmt_client.availability_sets.create_or_update(resource_group_name, name, params)
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def create_availability_set(resource_group_name, name, params)
          storage_acc = {
              name: name,
              location: params.location,
              resource_group_name: resource_group_name
          }
          storage_acc
        end
      end
    end
  end
end
