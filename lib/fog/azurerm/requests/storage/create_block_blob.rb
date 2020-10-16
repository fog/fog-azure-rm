module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def create_block_blob(container_name, blob_name, body, options = {})
          my_options = options.clone
          my_options[:request_id] = SecureRandom.uuid
          if my_options[:create_block_blob_timeout]
            Fog::Logger.debug "create_block_blob: Setting blob operation timeout to #{my_options[:create_block_blob_timeout]} seconds"
            my_options[:timeout] = my_options[:create_block_blob_timeout]
          else
            # Server side default is 10 minutes per megabyte on average, lets use an avg. speed of at least 100KiB/s
            # => 64MiB (max for create block) should be uploaded in 67108864B / 102400B/s = 655.36s
            Fog::Logger.debug 'create_block_blob: Setting blob operation timeout to default of 656 seconds'
            my_options[:timeout] = 656
          end

          msg = "create_block_blob #{blob_name} to the container #{container_name}. options: #{my_options}"
          Fog::Logger.debug msg

          begin
            if body.nil?
              data = nil
            elsif body.respond_to?(:read)
              if body.respond_to?(:rewind)
                begin
                  body.rewind
                rescue
                  nil
                end
              end
              data = body.read
            else
              data = Fog::Storage.parse_data(body)
              my_options[:content_length] = data[:headers]['Content-Length']
              my_options[:content_type] = data[:headers]['Content-Type']
              data = data[:body]
            end

            raise ArgumentError.new('The maximum size for a block blob created via create_block_blob is 64 MB.') if !data.nil? && Fog::Storage.get_body_size(data) > 64 * 1024 * 1024
            blob = @blob_client.create_block_blob(container_name, blob_name, data, my_options)
          rescue Azure::Core::Http::HTTPError => ex
            raise_azure_exception(ex, msg)
          end

          if data.nil?
            Fog::Logger.debug "Create a block blob #{blob_name} successfully."
          else
            Fog::Logger.debug "Upload a block blob #{blob_name} successfully."
          end
          blob
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def create_block_blob(_container_name, _blob_name, body, _options = {})
          Fog::Logger.debug 'Blob created successfully.'
          if body.nil?
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
          else
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
        end
      end
    end
  end
end
