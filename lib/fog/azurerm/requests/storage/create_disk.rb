module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def create_disk(blob_name, options = {})
          msg = "Creating disk(blob) #{blob_name}"
          Fog::Logger.debug msg
          ::File.open('out.txt', 'w') { |f| f.write('Sample File') }
          path = ::File.expand_path(::File.dirname('out.txt')) + '/' + 'out.txt'
          begin
            disk = upload_block_blob_from_file('vhds', "#{blob_name}.vhd", path.to_s, options)
          rescue Azure::Core::Http::HTTPError => e
            raise_azure_exception(e, msg)
          end
          disk
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def create_disk(*)
          Fog::Logger.debug 'Disk(Blob) created successfully.'
          {
            'name' => 'test_blob',
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
