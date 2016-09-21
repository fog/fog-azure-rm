module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def compare_blob(container1, container2)
          msg = "Comparing blobs from container #{container1} to container #{container2}"
          Fog::Logger.debug msg
          begin
            blobs_in_container1 = list_blobs(container1)
            blobs_in_container2 = list_blobs(container2)
            identical_blobs = get_identical_blobs_from_containers(blobs_in_container1, blobs_in_container2)
          rescue Azure::Core::Http::HTTPError => ex
            raise_azure_exception(ex, msg)
          end
          identical_blobs
        end

        private

        def get_identical_blobs_from_containers(container1_blobs, container2_blobs)
          identical_blobs = []
          container1_blobs.each do |container1_blob|
            container2_blobs.each do |container2_blob|
              container1_prop = container1_blob.get_properties
              container2_prop = container2_blob.get_properties
              if container1_prop.equal?(container2_prop) && container1_blob.name.equals?(container2_blob.name)
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
          ]
        end
      end
    end
  end
end
