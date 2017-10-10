module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def delete_generalized_image(resource_group, vm_name)
          msg = "Deleting Generalized Image: #{vm_name}-osImage"
          Fog::Logger.debug msg
          image_name = "#{vm_name}-osImage"
          begin
            @compute_mgmt_client.images.delete(resource_group, image_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Generalized Image #{image_name} deleted successfully."
          true
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def delete_generalized_image(*)
          Fog::Logger.debug 'Image fog-test-server-osImage from Resource group fog-test-rg deleted successfully.'
          true
        end
      end
    end
  end
end
