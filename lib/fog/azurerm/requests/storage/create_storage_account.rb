module Fog
  module Storage
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def create_storage_account(resource_group, name, account_type, location, replication)
          Fog::Logger.debug "Creating Storage Account: #{name}."
          params = define_params(account_type, location, replication)
          begin
            promise = @storage_mgmt_client.storage_accounts.create(resource_group, name, params)
            response = promise.value!
            Fog::Logger.debug 'Storage Account created successfully.'
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

        def define_params(account_type, location, replication)
          properties = ::Azure::ARM::Storage::Models::StorageAccountPropertiesCreateParameters.new
          properties.account_type = "#{account_type}_#{replication}"
          params = ::Azure::ARM::Storage::Models::StorageAccountCreateParameters.new
          params.properties = properties
          params.location = location
          params
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def create_storage_account(_resource_group, _name, account_type, location, replication)
          {
            'location' => location,
            'properties' =>
            {
              'accountType' => "#{account_type}_#{replication}",
              'lastGeoFailoverTime' => DateTime.parse(Time.now.to_s).strftime('%FT%TZ'),
              'creationTime' => DateTime.parse(Time.now.to_s).strftime('%FT%TZ')
            }
          }
        end
      end
    end
  end
end
