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
            body.properties.last_geo_failover_time = DateTime.parse(Time.now.to_s)
            body.properties.creation_time = DateTime.parse(Time.now.to_s)
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
        def create_storage_account(_resource_group, _name, params)
          {
            'location' => params.location,
            'properties' =>
                {
                    'accountType' => params.properties.account_type,
                    'lastGeoFailoverTime' => DateTime.parse(Time.now.to_s).strftime('%FT%TZ'),
                    'creationTime' => DateTime.parse(Time.now.to_s).strftime('%FT%TZ')
                }
          }
        end
      end
    end
  end
end
