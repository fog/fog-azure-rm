# rubocop:disable LineLength
module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def delete_storage_account(resource_group_name, name)
          @storage_mgmt_client.storage_accounts.delete(resource_group_name, name)
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def delete_storage_account(resource_group_name, name)
        end
      end
    end
  end
end
