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

        def self.get_blob_properties
          {
            'name' => name,
            'snapshot' => nil,
            'metadata' => {},
            'properties' =>
              {
                'last_modified' => 'Mon, 04 Jul 2016 09:30:31 GMT',
                'etag' => '0x8D3A3EDD7C2B777',
                'lease_status' => 'unlocked',
                'lease_state' => 'available',
                'lease_duration' => nil,
                'content_length' => 4_194_304,
                'content_type' => 'application/octet-stream',
                'content_encoding' => nil,
                'content_language' => nil,
                'content_disposition' => nil,
                'content_md5' => 'tXAohIyxuu/t94Lp/ujeRw==',
                'cache_control' => nil,
                'sequence_number' => 0,
                'blob_type' => 'PageBlob',
                'copy_id' => '095adc3b-e277-4c3d-97e0-0abca881f60c',
                'copy_status' => 'success',
                'copy_source' => 'https://testaccount.blob.core.windows.net/testblob/4m?snapshot=2016-02-04T08%3A35%3A50.3157696Z',
                'copy_progress' => '4194304/4194304',
                'copy_completion_time' => 'Thu, 04 Feb 2016 08:35:52 GMT',
                'copy_status_description' => nil,
                'accept_ranges' => 0
              }
          }
        end

        def self.list_blobs
          [
            {
              'name' => 'testblob1',
              'properties' =>
                {
                  'last_modified' => 'Mon, 04 Jul 2016 02:50:20 GMT',
                  'etag' => '0x8D3A3B5F017F52D',
                  'lease_status' => 'unlocked',
                  'lease_state' => 'available',
                  'content_length' => 4_194_304,
                  'content_type' => 'application/octet-stream',
                  'content_encoding' => nil,
                  'content_language' => nil,
                  'content_disposition' => nil,
                  'content_md5' => 'tXAohIyxuu/t94Lp/ujeRw==',
                  'cache_control' => nil,
                  'sequence_number' => 0,
                  'blob_type' => 'PageBlob',
                  'copy_id' => '095adc3b-e277-4c3d-97e0-0abca881f60c',
                  'copy_status' => 'success',
                  'copy_source' => 'https://testaccount.blob.core.windows.net/testblob/testblob1?snapshot=2016-02-04T08%3A35%3A50.3256874Z',
                  'copy_progress' => '4194304/4194304',
                  'copy_completion_time' => 'Thu, 04 Feb 2016 08:35:52 GMT',
                  'copy_status_description' => nil,
                  'accept_ranges' => 0
                },
              'metadata' => {}
            },
            {
              'name' => 'testblob2',
              'properties' =>
                {
                  'last_modified' => 'Tue, 04 Aug 2015 06:02:08 GMT',
                  'etag' => '0x8D29C92173526C8',
                  'lease_status' => 'unlocked',
                  'lease_state' => 'available',
                  'content_length' => 4_194_304,
                  'content_type' => 'application/octet-stream',
                  'content_encoding' => nil,
                  'content_language' => nil,
                  'content_disposition' => nil,
                  'content_md5' => 'tXAohIyxuu/t94Lp/ujeRw==',
                  'cache_control' => nil,
                  'sequence_number' => 0,
                  'blob_type' => 'PageBlob',
                  'copy_id' => '0abcdc3b-4c3d-e277-97e0-0abca881f60c',
                  'copy_status' => 'success',
                  'copy_source' => 'https://testaccount.blob.core.windows.net/testblob/testblob2?snapshot=2016-02-04T08%3A35%3A55.3157696Z',
                  'copy_progress' => '4194304/4194304',
                  'copy_completion_time' => 'Thu, 04 Feb 2016 08:40:52 GMT',
                  'copy_status_description' => nil,
                  'accept_ranges' => 0
                },
              'metadata' => {}
            }
          ]
        end
      end
    end
  end
end
