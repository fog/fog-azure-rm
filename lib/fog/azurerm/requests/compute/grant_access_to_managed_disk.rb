module Fog
  module Compute
    class AzureRM
      # Real class for Compute Request
      class Real
        def grant_access_to_managed_disk(resource_group_name, disk_name, access_type, duration_in_sec)
          msg = "Granting access to Managed Disk: #{disk_name}"
          Fog::Logger.debug msg
          access_data = Azure::Compute::Profiles::Latest::Mgmt::Models::GrantAccessData.new
          access_data.access = access_type
          access_data.duration_in_seconds = duration_in_sec
          begin
            access_uri = @compute_mgmt_client.disks.grant_access(resource_group_name, disk_name, access_data)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Access granted to managed disk: #{disk_name} successfully."
          access_uri.access_sas
        end
      end

      # Mock class for Compute Request
      class Mock
        def grant_access_to_managed_disk(*)
          'ACCESS URI'
        end
      end
    end
  end
end
