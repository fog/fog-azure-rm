module Fog
  module Compute
    class AzureRM
      # Real class for Compute Request
      class Real
        def get_image(resource_group_name, image_name)
          msg = "Getting Image #{image_name} in Resource Group #{resource_group_name}"
          Fog::Logger.debug msg
          begin
            image = @compute_mgmt_client.images.get(resource_group_name, image_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "#{msg} successful"
          image
        end
      end

      # Mock class for Compute Request
      class Mock
        def get_image(*)
          body = {
            'id' => '/subscriptions/########-####-####-####-############/resourceGroups/TestRG/providers/Microsoft.Compute/images/TestImage',
            'name' => 'TestImage',
            'resource_group' => 'TestRG',
            'location' => 'West US',
            'storage_profile' => {
              'os_disk' => {
                'os_type' => 'Linux',
                'os_state' => 'Generalized',
                'blob_uri' => 'https://myblob.blob.core.windows.net/images/testimage.vhd',
                'caching' => 'ReadWrite',
                'disk_size_gb' => '5'
              },
              'data_disks' => []
            },
            'provisioning_state' => 'Succeeded'
          }
          image_mapper = Azure::Compute::Profiles::Latest::Mgmt::Models::Image.mapper
          @compute_mgmt_client.deserialize(image_mapper, body, 'result.body')
        end
      end
    end
  end
end
