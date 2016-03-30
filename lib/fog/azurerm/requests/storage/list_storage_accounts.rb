module Fog
  module Storage
    class AzureRM
      class Real
        def list_storage_accounts(resource_group_name)
          response = @storage_mgmt_client.storage_accounts.list_by_resource_group(resource_group_name)
          result = response.value!
          result.body.value
        end
        def list_storage_accounts
          response = @storage_mgmt_client.storage_accounts.list
          result = response.value!
          result.body.value
        end
      end

      class Mock
        def list_storage_accounts
        end
      end
    end
  end
end
