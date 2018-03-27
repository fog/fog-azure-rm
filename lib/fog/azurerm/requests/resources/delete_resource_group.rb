module Fog
  module Resources
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def delete_resource_group(name)
          msg = "Deleting Resource Group: #{name}."
          Fog::Logger.debug msg

          url = "subscriptions/#{@subscription_id}/resourcegroups/#{name}?api-version=2017-05-10"

          begin
            Fog::AzureRM::NetworkAdapter.delete(
              url,
              @token
            )
          rescue => e
            raise e
          end
          Fog::Logger.debug "Resource Group #{name} deleted successfully."
          true
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def delete_resource_group(name)
          Fog::Logger.debug "Resource Group #{name} deleted successfully."
          true
        end
      end
    end
  end
end
