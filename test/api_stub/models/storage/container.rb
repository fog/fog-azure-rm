module ApiStub
  module Models
    module Storage
      # Mock class for Data Disk Model
      class Container
        def self.test_get_container_metadata
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
