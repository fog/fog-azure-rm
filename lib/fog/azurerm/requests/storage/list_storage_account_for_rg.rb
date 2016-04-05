# rubocop:disable LineLength
module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def list_storage_account_for_rg(resource_group)
          response = @storage_mgmt_client.storage_accounts.list_by_resource_group(resource_group)
          result = response.value!
          result.body.value
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def list_storage_account_for_rg(resource_group)
        end
      end
    end
  end
end
