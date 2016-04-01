module Fog
  module Storage
    class AzureRM
      class Real
        def list_storage_account_for_rg(resource_group_name)
          response = @storage_mgmt_client.storage_accounts.list_by_resource_group(resource_group_name)
          result = response.value!
          result.body.value
        end

      end

      class Mock
        def list_storage_account_for_rg(resource_group_name)
        end

      end
    end
  end
end
