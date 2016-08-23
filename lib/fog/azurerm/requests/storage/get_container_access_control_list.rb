module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def get_container_access_control_list(name, options = {})
          msg = "Get container ACL: #{name}."
          Fog::Logger.debug msg
          begin
            container_acl = @blob_client.get_container_acl(name, options)
            Fog::Logger.debug "Getting ACL of container #{name} successfully."
            container_acl
          rescue Azure::Core::Http::HTTPError => ex
            raise_azure_exception(ex, msg)
          end
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def get_container_access_control_list(*)
          [{
            'name' => 'testcontainer1',
            'public_access_level' => 'blob'
          }, {}]
        end
      end
    end
  end
end
