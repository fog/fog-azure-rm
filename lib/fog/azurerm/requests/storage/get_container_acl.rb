module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def get_container_acl(container_name, options = {})
          options[:request_id] = SecureRandom.uuid
          msg = "Get container ACL: #{container_name}. options: #{options}"
          Fog::Logger.debug msg

          begin
            container, signed_identifiers = @blob_client.get_container_acl(container_name, options)
          rescue Azure::Core::Http::HTTPError => ex
            raise_azure_exception(ex, msg)
          end

          Fog::Logger.debug "Getting ACL of container #{container_name} successfully."
          [container.public_access_level, signed_identifiers]
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def get_container_acl(*)
          ['container', {}]
        end
      end
    end
  end
end
