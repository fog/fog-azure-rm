module Fog
  module Compute
    class AzureRM
      # Real class for Compute Request
      class Real
        def list_images(resource_group_name, async = false)
          msg = 'Listing all Images'
          Fog::Logger.debug msg
          begin
            if async
              response = @compute_mgmt_client.images.list_by_resource_group_async(resource_group_name)
            else
              images = @compute_mgmt_client.images.list_by_resource_group(resource_group_name)
            end
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          if async
            response
          else
            Fog::Logger.debug 'Image listed successfully.'
            images
          end
        end
      end

      # Mock class for Compute Request
      class Mock
        def list_images(*)
          images = '[{
            "id": "/subscriptions/########-####-####-####-############/resourceGroups/TestRG/providers/Microsoft.Compute/images/TestImage",
            "name": "TestImage",
            "resource_group": "TestRG",
            "location": "West US",
            "storage_profile": {
              "os_disk": {
                "os_type": "Linux",
                "os_state": "Generalized",
                "blob_uri": "https://myblob.blob.core.windows.net/images/testimage.vhd",
                "caching": "ReadWrite",
                "disk_size_gb": "5"
              },
              "data_disks": []
            },
            "provisioning_state": "Succeeded"
          }]'
          image_mapper = Azure::ARM::Compute::Models::ImageListResult.mapper
          compute_client.deserialize(image_mapper, images, 'result.body')
        end
      end
    end
  end
end
