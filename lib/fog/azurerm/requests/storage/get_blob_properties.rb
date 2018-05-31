module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def get_blob_properties(container_name, name, options = {})
          options[:request_id] = SecureRandom.uuid
          msg = "Get Blob #{name} properties in container #{container_name}, options: #{options}."
          Fog::Logger.debug msg
          begin
            blob = @blob_client.get_blob_properties(container_name, name, options)
          rescue Azure::Core::Http::HTTPError => ex
            raise 'NotFound' if ex.message.include?('(404)')
            raise_azure_exception(ex, msg)
          end
          Fog::Logger.debug "Getting properties of blob #{name} successfully."
          blob
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def get_blob_properties(*)
          blob = Azure::Storage::Blob::Blob.new
          blob.name = 'test_blob'
          blob.metadata = {}
          blob.properties = {
              last_modified: 'Mon, 04 Jul 2016 09:30:31 GMT',
              etag: '0x8D3A3EDD7C2B777',
              lease_status: 'unlocked',
              lease_state: 'available',
              lease_duration: nil,
              content_length: 4_194_304,
              content_type: 'application/octet-stream',
              content_encoding: nil,
              content_language: nil,
              content_disposition: nil,
              content_md5: 'tXAohIyxuu/t94Lp/ujeRw==',
              cache_control: nil,
              sequence_number: 0,
              blob_type: 'PageBlob',
              copy_id: '095adc3b-e277-4c3d-97e0-0abca881f60c',
              copy_status: 'success',
              copy_source: 'https://testaccount.blob.core.windows.net/testblob/4m?snapshot=2016-02-04T08%3A35%3A50.3157696Z',
              copy_progress: '4194304/4194304',
              copy_completion_time: 'Thu, 04 Feb 2016 08:35:52 GMT',
              copy_status_description: nil,
              accept_ranges: 0
            }
          blob
        end
      end
    end
  end
end
