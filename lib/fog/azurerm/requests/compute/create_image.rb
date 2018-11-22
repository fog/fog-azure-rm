module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def create_image(image_config)
          msg = "Creating/Updating Image: #{image_config[:vm_name]}-osImage"
          Fog::Logger.debug msg
          image_name = "#{image_config[:vm_name]}-osImage"
          image = setup_params(image_config)
          begin
            image_obj = @compute_mgmt_client.images.create_or_update(image_config[:resource_group], image_name, image)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Image #{image_name} created/updated successfully."
          image_obj
        end

        private

        def setup_params(image_config)
          storage_profile_image = Azure::Compute::Profiles::Latest::Mgmt::Models::ImageStorageProfile.new
          storage_profile_image.os_disk = create_generalized_os_disk_image(image_config)
          image = Azure::Compute::Profiles::Latest::Mgmt::Models::Image.new
          image.storage_profile = storage_profile_image
          image.location = image_config[:location]
          image
        end

        def create_generalized_os_disk_image(image_config)
          os_disk_image = Azure::Compute::Profiles::Latest::Mgmt::Models::ImageOSDisk.new
          os_disk_image.os_type = image_config[:platform]
          os_disk_image.os_state = 'Generalized'
          os_disk_image.blob_uri = image_config[:new_vhd_path]
          os_disk_image.caching = Azure::Compute::Profiles::Latest::Mgmt::Models::CachingTypes::ReadWrite
          os_disk_image
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def create_image(*)
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
          image_mapper = Azure::Compute::Profiles::Latest::Mgmt::Models::Image.mapper
          @compute_mgmt_client.deserialize(image_mapper, image_obj, 'result.body')
        end
      end
    end
  end
end
