module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        BLOCK_SIZE = 32 * 1024 * 1024 # 32 MB

        def get_blob_with_block_given(container_name, blob_name, options, &block)
          options[:request_id] = SecureRandom.uuid
          msg = "get_blob_with_block_given: blob #{blob_name} in the container #{container_name}. options: #{options}"
          Fog::Logger.debug msg

          begin
            blob = @blob_client.get_blob_properties(container_name, blob_name, options)
          rescue Azure::Core::Http::HTTPError => ex
            raise 'NotFound' if ex.message.include?('(404)')
            raise_azure_exception(ex, msg)
          end

          content_length = blob.properties[:content_length]
          if content_length.zero?
            block.call('', 0, 0)
            return [blob, '']
          end

          start_range = 0
          end_range = content_length - 1
          start_range = options[:start_range] if options[:start_range]
          end_range = options[:end_range] if options[:end_range]
          raise ArgumentError.new(':end_range MUST be greater than :start_range') if start_range > end_range

          if start_range == end_range
            block.call('', 0, 0)
            return [blob, '']
          end

          buffer_size = BLOCK_SIZE
          buffer_size = options[:block_size] if options[:block_size]
          buffer_start_range = start_range
          total_bytes = end_range - start_range + 1
          params = options.dup

          while buffer_start_range < end_range
            buffer_end_range = [end_range, buffer_start_range + buffer_size - 1].min
            params[:start_range] = buffer_start_range
            params[:end_range] = buffer_end_range
            params[:request_id] = SecureRandom.uuid

            begin
              msg = "get_blob_with_block_given: blob #{blob_name} in the container #{container_name}. options: #{params}"
              Fog::Logger.debug msg
              _, content = @blob_client.get_blob(container_name, blob_name, params)
            rescue Azure::Core::Http::HTTPError => ex
              raise 'NotFound' if ex.message.include?('(404)')
              raise_azure_exception(ex, msg)
            end

            block.call(content, end_range - buffer_end_range, total_bytes)
            buffer_start_range += buffer_size
          end
          # No need to return content when block is given.
          [blob, '']
        end

        def get_blob(container_name, blob_name, options = {}, &block)
          if block_given?
            get_blob_with_block_given(container_name, blob_name, options, &block)
          else
            options[:request_id] = SecureRandom.uuid
            msg = "get_blob blob #{blob_name} in the container #{container_name}. options: #{options}"
            Fog::Logger.debug msg

            begin
              blob, content = @blob_client.get_blob(container_name, blob_name, options)
              Fog::Logger.debug "Get blob #{blob_name} successfully."
              [blob, content]
            rescue Azure::Core::Http::HTTPError => ex
              raise 'NotFound' if ex.message.include?('(404)')
              raise_azure_exception(ex, msg)
            end
          end
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def get_blob(_container_name, _blob_name, _options = {}, &block)
          Fog::Logger.debug 'get_blob successfully.'
          unless block_given?
            return [
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
              },
              'content'
            ]
          end
          data = StringIO.new('content')
          remaining = total_bytes = data.length
          while remaining > 0
            chunk = data.read([remaining, 2].min)
            block.call(chunk, remaining, total_bytes)
            remaining -= 2
          end

          [
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
            },
            ''
          ]
        end
      end
    end
  end
end
