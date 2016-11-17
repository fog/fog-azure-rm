module ApiStub
  module Models
    module Storage
      # Mock class for Data Disk Model
      class Directory
        def self.container
          {
            'name' => 'test_container',
            'public_access_level' => nil,
            'metadata' => {},
            'properties' => {
              'last_modified' => 'Mon, 04 Jul 2016 02:50:20 GMT',
              'etag' => '"0x8D3A3B5F017F52D"',
              'lease_status' => 'unlocked',
              'lease_state' => 'available'
            }
          }
        end

        def self.container_acl
          ['container', {}]
        end

        def self.container_https_url
          'https://sa.blob.core.windows.net/test_container?comp=list&restype=container'
        end

        def self.container_list
          [
            {
              'name' => 'test_container1',
              'metadata' => {},
              'properties' => {
                'last_modified' => 'Mon, 04 Jul 2016 02:50:20 GMT',
                'etag' => '"0x8D3A3B5F017F52D"',
                'lease_status' => 'unlocked',
                'lease_state' => 'available'
              }
            },
            {
              'name' => 'test_container2',
              'metadata' => {},
              'properties' => {
                'last_modified' => 'Tue, 04 Aug 2015 06:01:08 GMT',
                'etag' => '"0x8D29C92176C8352"',
                'lease_status' => 'unlocked',
                'lease_state' => 'available'
              }
            },
            {
              'name' => 'test_container3',
              'metadata' => {},
              'properties' => {
                'last_modified' => 'Tue, 01 Sep 2015 05:15:36 GMT',
                'etag' => '"0x8D2B28C5EB36458"',
                'lease_status' => 'unlocked',
                'lease_state' => 'available'
              }
            }
          ]
        end

        def self.blob_list
          {
            next_marker: 'marker',
            blobs:
            [
              {
                'name' => 'test_blob1',
                'metadata' => {},
                'properties' => {
                  'last_modified' => 'Mon, 04 Jul 2016 02:50:20 GMT',
                  'etag' => '"0x8D3A3B5F017F52D"',
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
                  'copy_source' => 'https://testaccount.blob.core.windows.net/test_container/test_blob?snapshot=2016-02-04T08%3A35%3A50.3256874Z',
                  'copy_progress' => '4194304/4194304',
                  'copy_completion_time' => 'Thu, 04 Feb 2016 08:35:52 GMT',
                  'copy_status_description' => nil,
                  'accept_ranges' => 0
                }
              },
              {
                'name' => 'test_blob2',
                'metadata' => {},
                'properties' => {
                  'last_modified' => 'Tue, 04 Aug 2015 06:02:08 GMT',
                  'etag' => '"0x8D29C92173526C8"',
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
                  'copy_source' => 'https://testaccount.blob.core.windows.net/test_container/test_blob?snapshot=2016-02-04T08%3A35%3A55.3157696Z',
                  'copy_progress' => '4194304/4194304',
                  'copy_completion_time' => 'Thu, 04 Feb 2016 08:40:52 GMT',
                  'copy_status_description' => nil,
                  'accept_ranges' => 0
                }
              },
              {
                'name' => 'test_blob3',
                'metadata' => {},
                'properties' => {
                  'last_modified' => 'Tue, 04 Aug 2015 06:02:08 GMT',
                  'etag' => '"0x8D29C92173526C8"',
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
                  'copy_source' => 'https://testaccount.blob.core.windows.net/test_container/test_blob?snapshot=2016-02-04T08%3A35%3A55.3157696Z',
                  'copy_progress' => '4194304/4194304',
                  'copy_completion_time' => 'Thu, 04 Feb 2016 08:40:52 GMT',
                  'copy_status_description' => nil,
                  'accept_ranges' => 0
                }
              },
              {
                'name' => 'test_blob4',
                'metadata' => {},
                'properties' => {
                  'last_modified' => 'Tue, 04 Aug 2015 06:02:08 GMT',
                  'etag' => '"0x8D29C92173526C8"',
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
                  'copy_source' => 'https://testaccount.blob.core.windows.net/test_container/test_blob?snapshot=2016-02-04T08%3A35%3A55.3157696Z',
                  'copy_progress' => '4194304/4194304',
                  'copy_completion_time' => 'Thu, 04 Feb 2016 08:40:52 GMT',
                  'copy_status_description' => nil,
                  'accept_ranges' => 0
                }
              }
            ]
          }
        end
      end
    end
  end
end
