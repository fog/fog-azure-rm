module Fog
  module Compute
    class AzureRM
      # Real class for Compute Request
      class Real
        def check_managed_disk_exists(resource_group_name, disk_name)
          msg = "Checking if Managed Disk: #{disk_name} exists"
          Fog::Logger.debug msg
          begin
            @compute_mgmt_client.disks.get(resource_group_name, disk_name)
            Fog::Logger.debug "Managed Disk #{disk_name} exist."
            true
          rescue MsRestAzure::AzureOperationError => e
            if e.error_code == 'ResourceNotFound'
              Fog::Logger.debug "Managed Disk #{disk_name} doesn't exist."
              false
            else
              raise_azure_exception(e, msg)
            end
          end
        end
      end

      # Mock class for Compute Request
      class Mock
        def check_managed_disk_exists(*)
          Fog::Logger.debug 'Managed Disk test-disk from Resource group fog-rg is available.'
          true
        end
      end
    end
  end
end
