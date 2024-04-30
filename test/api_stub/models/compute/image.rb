module ApiStub
  module Models
    module Compute
      class Image
        def self.image_response(sdk_compute_client)
          image = {
            'id' => '/subscriptions/{subscription_id}/resourceGroups/ManagedRG/providers/Microsoft.Compute/image/image-name',
            'location' => 'West US',
            'tags' => {
              'key' => 'value'
            },
            'properties' => {
              'source_virtual_machine' => {
                'id' => '/subscriptions/{subscription_id}/resourceGroups/fog-test-rg/providers/Microsoft.Compute/virtualMachines/vm-name'
              },
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

          result_mapper = Azure::ARM::Compute::Models::Image.mapper
          sdk_compute_client.deserialize(result_mapper, image, 'result.body')
        end
      end
    end
  end
end
