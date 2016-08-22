module ApiStub
  module Requests
    module Storage
      # Mock class for Storage Requests
      class StorageAccount
        def self.storage_account_request(client)
          body = {
            'id' => '/subscriptions/67f2116d-4ea2-4c6c-b20a-f92183dbe3cb/resourceGroups/fog_test_rg/providers/Microsoft.Storage/storageAccounts/fogtestsasecond',
            'name' => 'fog-test-storage-account',
            'location' => 'west us',
            'sku' =>
              {
                'name' => 'Standard_LRS'
              }
          }
          mapper = Azure::ARM::Storage::Models::StorageAccount.mapper
          client.deserialize(mapper, body, 'hash')
        end

        def self.create_storage_account
          storage_acc_obj = Azure::ARM::Storage::Models::StorageAccount.new
          storage_acc_obj.id = '1'
          storage_acc_obj.name = 'fog_test_storage_account'
          storage_acc_obj.type = nil
          storage_acc_obj.location = 'west us'
          storage_acc_obj.tags = nil
          storage_acc_obj.properties = nil
          storage_acc_obj
        end

        def self.storage_account_arguments
          {
            resource_group: 'gateway-RG',
            name: 'fog_test_storage_account',
            sku_name: 'Standard',
            location: 'West US',
            replication: 'LRS'
          }
        end

        def self.list_storage_accounts_for_rg(client)
          body = {
            'value' =>
              [
                {
                  'id' => '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}',
                  'name' => 'accountName1',
                  'location' => 'account geo region',
                  'tags' =>
                    {
                      'key1' => 'value1',
                      'key2' => 'value2'
                    },
                  'type' => 'Microsoft.Storage/StorageAccount',
                  'properties' =>
                    {
                      'lastGeoFailoverTime' => '',
                      'creationTime' => '2016-05-18T07:24:40Z'
                    }
                }
              ]
          }
          mapper = Azure::ARM::Storage::Models::StorageAccountListResult.mapper
          client.deserialize(mapper, body, 'hash')
        end

        def self.list_storage_accounts(client)
          body = {
            'value' =>
              [
                {
                  'id' => '/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}',
                  'name' => 'accountName1',
                  'type' => 'Microsoft.Storage/StorageAccount',
                  'location' => 'account geo region',
                  'tags' =>
                    {
                      'key1' => 'value1',
                      'key2' => 'value2'
                    },
                  'properties' =>
                    {
                      'lastGeoFailoverTime' => '',
                      'creationTime' => '2016-05-18T07:24:40Z'
                    }
                }
              ]
          }
          mapper = Azure::ARM::Storage::Models::StorageAccountListResult.mapper
          client.deserialize(mapper, body, 'hash')
        end

        def self.true_case_for_check_name_availability(client)
          result = {
            'nameAvailable' => true,
            'reason' => 'AccountNameInvalid|AlreadyExists',
            'message' => 'error message'
          }
          mapper = Azure::ARM::Storage::Models::CheckNameAvailabilityResult.mapper
          client.deserialize(mapper, result, 'hash')
        end

        def self.false_case_for_check_name_availability(client)
          result = {
            'nameAvailable' => false,
            'reason' => 'AccountNameInvalid|AlreadyExists',
            'message' => 'error message'
          }
          mapper = Azure::ARM::Storage::Models::CheckNameAvailabilityResult.mapper
          client.deserialize(mapper, result, 'hash')
        end

        def self.azure_operation_response(body)
          MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new, Azure::ARM::Storage::Models::CheckNameAvailabilityResult.deserialize_object(body))
        end

        def self.response_storage_account_list(body)
          MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new, Azure::ARM::Storage::Models::StorageAccountListResult.deserialize_object(body))
        end

        def self.list_keys_response
          key1 = Azure::ARM::Storage::Models::StorageAccountKey.new
          key1.key_name = 'key1'
          key1.value = 'sfhyuiafhhfids0943'
          key1.permissions = 'Full'
          storage_account_key_list = Azure::ARM::Storage::Models::StorageAccountListKeysResult.new
          storage_account_key_list.keys = [key1]
          storage_account_key_list
        end
      end
    end
  end
end
