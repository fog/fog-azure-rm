module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def get_container_metadata(name)
          Fog::Logger.debug "Get Container #{name} metadata."
          begin
            container = @blob_client.get_container_metadata(name)
            Fog::Logger.debug "Getting metadata of container #{name} successfully."
            container.metadata
          rescue Azure::Core::Http::HTTPError => ex
            raise "Exception in getting metadata of Container #{name}: #{ex.inspect}"
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def get_container_metadata(name)
          {
              "container-name" => name,
              "created-by" => "User",
              "source-machine"=>"Test-machine",
              "category"=>"guidance",
              "doctype"=>"textDocuments"
          }
        end
      end
    end
  end
end
