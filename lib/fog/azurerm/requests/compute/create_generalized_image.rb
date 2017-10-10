module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def create_generalized_image(image_config)
          msg = "Creating/Updating Generalized Image: #{image_config[:vm_name]}-osImage"
          Fog::Logger.debug msg
          image_name = "#{image_config[:vm_name]}-osImage"
          image = setup_image_params(image_config)
          begin
            image_obj = @compute_mgmt_client.images.create_or_update(image_config[:resource_group], image_name, image)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Generalized Image #{image_name} created/updated successfully."
          image_obj
        end

        def setup_image_params(image_config)
          os_disk_image = Azure::ARM::Compute::Models::ImageOSDisk.new
          os_disk_image.os_type = image_config[:platform]
          os_disk_image.os_state = 'Generalized'
          os_disk_image.blob_uri = image_config[:new_vhd_path]
          os_disk_image.caching = Azure::ARM::Compute::Models::CachingTypes::ReadWrite
          storage_profile_image = Azure::ARM::Compute::Models::ImageStorageProfile.new
          storage_profile_image.os_disk = os_disk_image
          image = Azure::ARM::Compute::Models::Image.new
          image.storage_profile = storage_profile_image
          image.location = image_config[:location]
          image
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def create_generalized_image(*)
          image_obj = {
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
          @compute_mgmt_client.deserialize(image_mapper, image_obj, 'result.body')
        end
      end
    end
  end
end
