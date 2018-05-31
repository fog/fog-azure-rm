module ApiStub
  module Requests
    module Storage
      # Mock class for Deployment Requests
      # Below data should be as same as those in Mock classes in lib/fog/azurerm/requests/storage/*.rb
      class File
        def self.blob
          blob_data = blob_as_hash
          blob = Azure::Storage::Blob::Blob.new
          blob.name = blob_data['name']
          blob.metadata = blob_data['metadata']
          # properties = {}
          # blob_data['properties'].keys.each { |key| properties[key.to_sym] = blob_data['properties'][key] }
          # blob.properties = properties
          blob.properties = blob_data['properties'].map { |k,v| { k.to_sym => v } }.reduce({}, &:merge!)
          blob
        end

        def self.blob_as_hash
          {
            'name' => 'test_blob',
            'metadata' => {},
            'properties' => {
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

        def self.blob_https_url(environment = ENVIRONMENT_AZURE_CLOUD)
          case environment
          when ENVIRONMENT_AZURE_CHINA_CLOUD
            'https://sa.blob.core.chinacloudapi.cn/test_container/test_blob'
          when ENVIRONMENT_AZURE_US_GOVERNMENT
            'https://sa.blob.core.usgovcloudapi.net/test_container/test_blob'
          when ENVIRONMENT_AZURE_GERMAN_CLOUD
            'https://sa.blob.core.cloudapi.de/test_container/test_blob'
          else
            'https://sa.blob.core.windows.net/test_container/test_blob'
          end
        end

        def self.blob_url_token
          'token'
        end

        def self.blob_lease_id
          {
            'leaseId' => 'abc123'
          }
        end

        def self.blob_metadata
          {
            'created-by' => 'User',
            'source-machine' => 'Test-machine',
            'category' => 'guidance',
            'doctype' => 'textDocuments'
          }
        end

        def self.blob_copy_result
          # copy_id, copy_status
          %w(abc123 pending)
        end

        def self.block_blob
          {
            'name' => 'test_blob',
            'metadata' => {},
            'properties' => {
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
              'blob_type' => 'BlockBlob',
              'copy_id' => '095adc3b-e277-4c3d-97e0-0abca881f60c',
              'copy_status' => 'success',
              'copy_source' => 'https://testaccount.blob.core.windows.net/test_container/test_blob?snapshot=2016-02-04T08%3A35%3A50.3256874Z',
              'copy_progress' => '4194304/4194304',
              'copy_completion_time' => 'Thu, 04 Feb 2016 08:35:52 GMT',
              'copy_status_description' => nil,
              'accept_ranges' => 0
            }
          }
        end

        def self.emtpy_block_blob
          {
            'name' => 'test_blob',
            'metadata' => {},
            'properties' => {
              'last_modified' => 'Mon, 04 Jul 2016 02:50:20 GMT',
              'etag' => '0x8D3A3B5F017F52D',
              'lease_status' => nil,
              'lease_state' => nil,
              'content_length' => 0,
              'content_type' => 'application/octet-stream',
              'content_encoding' => nil,
              'content_language' => nil,
              'content_disposition' => nil,
              'content_md5' => nil,
              'cache_control' => nil,
              'sequence_number' => 0,
              'blob_type' => 'BlockBlob',
              'copy_id' => nil,
              'copy_status' => nil,
              'copy_source' => nil,
              'copy_progress' => nil,
              'copy_completion_time' => nil,
              'copy_status_description' => nil,
              'accept_ranges' => 0
            }
          }
        end

        def self.blob_list
          [
            {
              'name' => 'test_blob1',
              'metadata' => {},
              'properties' => {
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
                'copy_source' => 'https://testaccount.blob.core.windows.net/test_container/test_blob?snapshot=2016-02-04T08%3A35%3A55.3157696Z',
                'copy_progress' => '4194304/4194304',
                'copy_completion_time' => 'Thu, 04 Feb 2016 08:40:52 GMT',
                'copy_status_description' => nil,
                'accept_ranges' => 0
              }
            }
          ]
        end
      end
    end
  end
end
