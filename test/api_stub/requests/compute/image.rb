module ApiStub
  module Requests
    module Compute
      # Mock class for Virtual Machine Requests
      class Image
        def self.image_params
          {
            resource_group: 'fog-test-rg',
            vm_name: 'fog-test-server',
            location: 'westus',
            platform: 'Linux',
            new_vhd_path: 'https://mystorageaccount.blob.core.windows.net/osimages/osimage.vhd'
          }
        end

        def self.create_image(compute_client)
          body = {
            'id' => '/subscriptions/{subscription_id}/resourceGroups/ManagedRG/providers/Microsoft.Compute/image/image-name',
            'location' => 'West US',
            'tags' => {
              'key' => 'value'
            },
            'properties' => {
              'storageProfile' => {
                'osDisk' => {
                  'osType' => 'Linux',
                  'blobUri' => 'https://mystorageaccount.blob.core.windows.net/osimages/osimage.vhd',
                  'osState' => 'generalized',
                  'hostCaching' => 'readwrite',
                  'storageAccountType' => 'Standard_LRS'
                },
                'provisioningState' => 'Succeeded'
              }
            }
          }
          image_mapper = Azure::ARM::Compute::Models::Image.mapper
          compute_client.deserialize(image_mapper, body, 'result.body')
        end
      end
    end
  end
end
