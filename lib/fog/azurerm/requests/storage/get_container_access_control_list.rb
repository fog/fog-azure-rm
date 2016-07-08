module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def get_container_access_control_list(name, options = {})
          Fog::Logger.debug "Get container ACL: #{name}."
          begin
            container = @blob_client.get_container_acl(name, options)
            Fog::Logger.debug 'Getting ACL of container #{name} successfully.'
            container
          rescue Azure::Core::Http::HTTPError => ex
            raise "Exception in getting ACL of container #{name}: #{ex.inspect}"
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
