
module Fog
  module Compute
    class AzureRM
      # Real class for Compute Request
      class Real
        def delete_managed_disk(resource_group_name, disk_name)
          msg = "Deleting Managed Disk: #{disk_name}"
          Fog::Logger.debug msg
          begin
            @compute_mgmt_client.disks.delete(resource_group_name, disk_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Managed Disk #{disk_name} deleted successfully."
          true
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
