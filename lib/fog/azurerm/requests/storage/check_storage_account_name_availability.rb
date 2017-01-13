module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def check_storage_account_name_availability(storage_account_name, storage_account_type)
          msg = "Checking Storage Account Name availability: #{storage_account_name}."
          Fog::Logger.debug msg

          storage_account_params = create_storage_account_params(storage_account_name, storage_account_type)
          begin
            name_available_obj = @storage_mgmt_client.storage_accounts.check_name_availability(storage_account_params)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          if name_available_obj.name_available
            Fog::Logger.debug "Name: #{storage_account_name} is available."
            true
          else
            Fog::Logger.debug "Name: #{storage_account_type} is not available."
            Fog::Logger.debug "Reason: #{name_available_obj.reason}."
            false
          end
        end

        private

        def create_storage_account_params(name, type)
          params = Azure::ARM::Storage::Models::StorageAccountCheckNameAvailabilityParameters.new
          params.name = name
          params.type = type
          params
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
