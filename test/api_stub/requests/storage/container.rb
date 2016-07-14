module ApiStub
  module Requests
    module Storage
      # Mock class for Deployment Requests
      class Container
        def self.test_get_container_metadata
          container = Azure::Storage::Blob::Container::Container.new
          container.name = 'test-container'
          container.metadata = metadata_response
          container
        end

        def self.metadata_response
          {
            'container-name' => 'Test-container',
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
