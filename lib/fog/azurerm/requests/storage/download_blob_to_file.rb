module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def download_blob_to_file(container_name, blob_name, file_path, options = {})
          Fog::Logger.debug "Downloading file #{file_path} from blob #{blob_name} in the container #{container_name}."

          begin
            blob, content = @blob_client.get_blob(container_name, blob_name, options)
            IO.binwrite(File.expand_path(file_path), content)
            blob
          rescue IOError => ex
            raise "Exception in writing #{file_path}: #{ex.inspect}"
          rescue Azure::Core::Http::HTTPError => ex
            raise "Exception in downloading blob #{blob_name}: #{ex.inspect}"
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def download_blob_to_file(_container_name, blob_name, _options = {})
          {
            'name' => blob_name,
            'metadata' => {},
            'properties' =>
              {
                'last_modified' => 'Thu, 28 Jul 2016 06:53:05 GMT',
                'etag' => '0x8D3B6B3D353FFCA',
                'lease_status' => 'unlocked',
                'lease_state' => 'available',
                'lease_duration' => nil,
                'content_length' => 4_194_304,
                'content_type' => 'application/atom+xml; charset=utf-8',
                'content_encoding' => 'ASCII-8BIT',
                'content_language' => nil,
                'content_disposition' => nil,
                'content_md5' => 'tXAohIyxuu/t94Lp/ujeRw==',
                'cache_control' => nil,
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
      end
    end
  end
end
