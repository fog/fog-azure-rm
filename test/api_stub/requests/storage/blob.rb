module ApiStub
  module Requests
    module Storage
      # Mock class for Deployment Requests
      class Blob
        def self.test_get_blob_metadata
          container = Azure::Storage::Blob::Blob.new
          container.name = 'Test-blob'
          container.metadata = metadata_response
          container
        end

        def self.metadata_response
          {
            'container-name' => 'Test-container',
            'blob-name' => 'Test-blob',
            'category' => 'Images',
            'resolution' => 'High'
          }
        end
      end
    end
  end
end
