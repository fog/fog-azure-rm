module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        SINGLE_BLOB_PUT_THRESHOLD = 32 * 1024 * 1024
        BLOCK_SIZE = 4 * 1024 * 1024

        def upload_block_blob_from_file(container_name, blob_name, file_path, options = {})
          Fog::Logger.debug "Uploading file #{file_path} as blob #{blob_name} to the container #{container_name}."
          if file_path.nil?
            blob = @blob_client.create_block_blob container_name, blob_name, nil, options
            Fog::Logger.debug "Blob #{blob_name} created successfully."
            return blob
          end

          begin
            size = ::File.size file_path

            if size <= SINGLE_BLOB_PUT_THRESHOLD
              blob = @blob_client.create_block_blob container_name, blob_name, IO.binread(::File.expand_path(file_path)), options
            else
              blocks = []
              ::File.open file_path, 'rb' do |file|
                while (read_bytes = file.read(BLOCK_SIZE))
                  block_id = Base64.strict_encode64 random_string(32)
                  @blob_client.put_blob_block container_name, blob_name, block_id, read_bytes, options
                  blocks << [block_id]
                end
              end
              blob = @blob_client.commit_blob_blocks container_name, blob_name, blocks, options
            end

            Fog::Logger.debug "Uploading #{file_path} successfully."
            blob
          rescue IOError => ex
            raise "Exception in reading #{file_path}: #{ex.inspect}"
          rescue Azure::Core::Http::HTTPError => ex
            raise "Exception in uploading #{file_path}: #{ex.inspect}"
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def upload_block_blob_from_file(_container_name, blob_name, _file_path, _options = {})
          Fog::Logger.debug 'Blob created successfully.'
          {
            'name' => blob_name,
            'properties' =>
              {
                'last_modified' => 'Thu, 28 Jul 2016 06:53:05 GMT',
                'etag' => '0x8D3B6B3D353FFCA',
                'content_md5' => 'tXAohIyxuu/t94Lp/ujeRw=='
              }
          }
        end
      end
    end
  end
end
