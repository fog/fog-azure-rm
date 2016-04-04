module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def check_storage_account_name_availability(name)
          @storage_mgmt_client.storage_accounts.check_name_availability(name)
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def check_storage_account_name_availability(name)
        end
      end
    end
  end
end
