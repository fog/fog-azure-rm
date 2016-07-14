module ApiStub
  module Models
    module Storage
      # Mock class for Data Disk Model
      class Blob
        def self.test_get_blob_metadata
          {
            'container-name' => 'Test-container',
            'blob-name' => 'Test_Blob',
            'category' => 'Images',
            'resolution' => 'High'
          }
        end
      end
    end
  end
end
