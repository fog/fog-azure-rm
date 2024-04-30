module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def create_image(image_config)
          msg = "Creating/Updating Image: #{image_config[:vm_name]}-osImage"
          Fog::Logger.debug msg
          image_name = image_config.delete(:name) || "#{image_config[:vm_name]}-osImage"
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
          image = Azure::ARM::Compute::Models::Image.new
          if image_config[:source_virtual_machine_id]
            image.source_virtual_machine = setup_source_virtual_machine(image_config)
          else
            image.storage_profile = setup_storage_profile_image(image_config)
          end
          image.location = image_config[:location]
          image
        end

        def setup_storage_profile_image(image_config)
          storage_profile_image = Azure::ARM::Compute::Models::ImageStorageProfile.new
          storage_profile_image.os_disk = create_generalized_os_disk_image(image_config)
          storage_profile_image
        end

        def create_generalized_os_disk_image(image_config)
          os_disk_image = Azure::ARM::Compute::Models::ImageOSDisk.new
          os_disk_image.os_type = image_config[:platform]
          os_disk_image.os_state = 'Generalized'
          if image_config[:new_vhd_path]
            os_disk_image.blob_uri = image_config[:new_vhd_path]
          elsif image_config[:managed_disk_id]
            os_disk_image.managed_disk = create_managed_disk_image(image_config)
          end
          os_disk_image.caching = Azure::ARM::Compute::Models::CachingTypes::ReadWrite
          os_disk_image
        end

        def create_managed_disk_image(image_config)
          managed_disk_image = Azure::ARM::Compute::Models::Disk.new
          managed_disk_image.id = image_config[:managed_disk_id]
          managed_disk_image
        end

        def setup_source_virtual_machine(image_config)
          source_virtual_machine = Azure::ARM::Compute::Models::VirtualMachine.new
          source_virtual_machine.id = image_config[:source_virtual_machine_id]
          source_virtual_machine
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
          image_mapper = Azure::ARM::Compute::Models::Image.mapper
          @compute_mgmt_client.deserialize(image_mapper, image_obj, 'result.body')
        end
      end
    end
  end
end
