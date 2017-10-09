module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def delete_generalized_image(resource_group, vm_name)
          image_name = "#{vm_name}-osImage"
          @compute_mgmt_client.images.delete(resource_group, image_name)
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def delete_generalized_image(*)
          Fog::Logger.debug 'Image fog-test-image from Resource group fog-test-rg deleted successfully.'
          true
        end
      end
    end
  end
end