module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def put_container_acl(name, acl, options = {})
          options[:request_id] = SecureRandom.uuid
          msg = "Setting Container #{name} acl #{acl.nil? ? 'nil' : acl}. options: #{options}"
          Fog::Logger.debug msg

          begin
            @blob_client.set_container_acl(name, acl, options)
          rescue Azure::Core::Http::HTTPError => ex
            raise_azure_exception(ex, msg)
          end

          Fog::Logger.debug "Setting acl of container #{name} successfully."
          true
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def put_container_acl(*)
          Fog::Logger.debug 'Set Container testcontainer1 acl successfully.'
          true
        end
      end
    end
  end
end
