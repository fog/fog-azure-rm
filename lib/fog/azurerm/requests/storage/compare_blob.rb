module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def compare_blob(container1, container2)
          msg = "Comparing blobs from container #{container1} to container #{container2}"
          Fog::Logger.debug msg
          begin
            identical_blobs = get_identical_blobs_from_containers(container1, container2)
          rescue Azure::Core::Http::HTTPError => ex
            raise_azure_exception(ex, msg)
          end
          identical_blobs
        end

        private

        def get_identical_blobs_from_containers(container1, container2)
          container1_blobs = list_blobs(container1)
          container2_blobs = list_blobs(container2)

          identical_blobs = []
          container1_blobs.each do |container1_blob|
            container2_blobs.each do |container2_blob|
              container1_prop = get_blob_properties(container1, container1_blob.name)
              container2_prop = get_blob_properties(container2, container2_blob.name)
              if container1_blob.name == container2_blob.name && container1_prop.properties[:content_md5] == container2_prop.properties[:content_md5]
                identical_blobs.push(container1_blob)
              end
            end
          end
          identical_blobs
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def compare_blob(*)
          [
            {
              'name' => 'blob_name',
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
          ]
        end
      end
    end
  end
end
