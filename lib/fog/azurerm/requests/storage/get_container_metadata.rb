module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def get_container_metadata(name)
          msg = "Getting Container #{name} metadata."
          Fog::Logger.debug msg
          begin
            container = @blob_client.get_container_metadata(name)
            Fog::Logger.debug "Getting metadata of container #{name} successfully."
            container.metadata
          rescue Azure::Core::Http::HTTPError => ex
            raise_azure_exception(ex, msg)
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def get_container_metadata(*)
          {
            'container-name' => 'testcontainer1',
            'created-by' => 'User',
            'source-machine' => 'Test-machine',
            'category' => 'guidance',
            'doctype' => 'textDocuments'
          }
        end
      end
    end
  end
end
