
module Fog
  module Compute
    class AzureRM
      # Real class for Compute Request
      class Real
        def delete_managed_disk(resource_group_name, disk_name, async)
          msg = "Deleting Managed Disk: #{disk_name}"
          Fog::Logger.debug msg
          begin
            if async
              response = @compute_mgmt_client.disks.delete_async(resource_group_name, disk_name)
            else
              @compute_mgmt_client.disks.delete(resource_group_name, disk_name)
            end
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          if async
            response
          else
            Fog::Logger.debug "Managed Disk #{disk_name} deleted successfully."
            true
          end
        end
      end

      # Mock class for Compute Request
      class Mock
        def delete_managed_disk(*)
          Fog::Logger.debug 'Managed Disk test-disk from Resource group fog-test-rg deleted successfully.'
          true
        end
      end
    end
  end
end
