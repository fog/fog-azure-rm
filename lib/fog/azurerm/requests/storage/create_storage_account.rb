module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def create_storage_account(resource_group, name, params)
          Fog::Logger.debug "Creating Storage Account: #{name}."
          begin
            promise = @storage_mgmt_client.storage_accounts.create(resource_group, name, params)
            response = promise.value!
            Fog::Logger.debug "Storage Account created successfully."
            body = response.body
            properties = body.instance_variable_get(:@properties)
            properties.instance_variable_set(:@last_geo_failover_time, DateTime.new(2016,05,16))
            properties.instance_variable_set(:@creation_time, DateTime.new(2016,05,16))
            result = Azure::ARM::Storage::Models::StorageAccount.serialize_object(response.body)
            result
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception creating Storage Account #{name} in Resource Group #{resource_group}. #{e.body['error']['message']}"
            raise msg
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def create_storage_account(resource_group, name, params)
          storage_acc = {
            name: name,
            location: params.location,
            resource_group: resource_group
          }
          storage_acc
        end
      end
    end
  end
end
