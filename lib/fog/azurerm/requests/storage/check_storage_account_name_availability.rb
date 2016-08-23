module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def check_storage_account_name_availability(params)
          msg = "Checking Name availability: #{params.name}."
          Fog::Logger.debug msg
          begin
            name_available_obj = @storage_mgmt_client.storage_accounts.check_name_availability(params)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          if name_available_obj.name_available
            Fog::Logger.debug "Name: #{params.name} is available."
            true
          else
            Fog::Logger.debug "Name: #{params.name} is not available."
            Fog::Logger.debug "Reason: #{name_available_obj.reason}."
            false
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def check_storage_account_name_availability(params)
          Fog::Logger.debug "Name: #{params.name} is available."
          true
        end
      end
    end
  end
end
