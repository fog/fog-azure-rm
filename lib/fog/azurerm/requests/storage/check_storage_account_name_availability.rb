module Fog
  module Storage
    class AzureRM
      class Real
        def check_storage_account_name_availability(name)
          @storage_mgmt_client.storage_accounts.check_name_availability(name)
        end
      end

      class Mock
        def check_storage_account_name_availability(name)
        end
      end
    end
  end
end
