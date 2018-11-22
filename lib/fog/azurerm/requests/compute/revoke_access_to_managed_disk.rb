module Fog
  module Compute
    class AzureRM
      # Real class for Compute Request
      class Real
        def revoke_access_to_managed_disk(resource_group_name, disk_name)
          msg = "Revoking access to Managed Disk: #{disk_name}"
          Fog::Logger.debug msg
          begin
            response = @compute_mgmt_client.disks.revoke_access(resource_group_name, disk_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Access revoked to managed disk: #{disk_name} successfully."
          response
        end
      end

      # Mock class for Compute Request
      class Mock
        def revoke_access_to_managed_disk(*)
          response = {
            'name' => 'revoke',
            'status' => 200,
            'error' => 'Error Details'
          }
          response_mapper = Azure::Compute::Profiles::Latest::Mgmt::Models::OperationStatusResponse.mapper
          @compute_mgmt_client.deserialize(response_mapper, response, 'result.body')
        end
      end
    end
  end
end
