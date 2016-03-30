module Fog
  module Storage
    class AzureRM
      class Real
        def delete_storage_account(resource_group_name, name)
          @storage_mgmt_client.storage_accounts.delete(resource_group_name, name)
        end
      end

      class Mock
        def delete_storage_account(resource_group_name, name)
        end
      end
    end
  end
end
