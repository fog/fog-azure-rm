module ApiStub
  module Requests
    module Storage
      class StorageAccount

        def self.create_storage_account
          storage_acc_obj = Azure::ARM::Storage::Models::StorageAccount.new
          storage_acc_obj.id = '1'
          storage_acc_obj.name = 'awain'
          storage_acc_obj.type = nil
          storage_acc_obj.location = 'west us'
          storage_acc_obj.tags = nil
          storage_acc_obj.properties = nil
          storage_acc_obj
        end
        def self.list_storage_accounts_for_rg
          {
              "value" => [
                  {
                      "id"=> "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}",
                      "name"=> "accountName1",
                      "location"=> "account geo region",
                      "tags"=> {
                          "key1"=> "value1",
                          "key2"=> "value2"
                      },
                      "type"=> "Microsoft.Storage/StorageAccount",
                      "properties"=> {},
                      "sku"=> {
                          "name"=> "Standard_LRS|Standard_ZRS|Standard_GRS|Standard_RAGRS|Premium_LRS",
                          "tier"=> "Standard|Premium"
                      },
                      "kind"=> "Storage"
                  }
              ]
          }
        end
        def self.list_storage_accounts
          {
              "value" => [
                  {
                      "id"=> "/subscriptions/{subscriptionId}/resourceGroups/{resourceGroupName}/providers/Microsoft.Storage/storageAccounts/{accountName}",
                      "name"=> "accountName1",
                      "location"=> "account geo region",
                      "tags"=> {
                          "key1"=> "value1",
                          "key2"=> "value2"
                      },
                      "type"=> "Microsoft.Storage/StorageAccount",
                      "properties"=> {},
                      "sku"=> {
                          "name"=> "Standard_LRS|Standard_ZRS|Standard_GRS|Standard_RAGRS|Premium_LRS",
                          "tier"=> "Standard|Premium"
                      },
                      "kind"=> "Storage"
                  }
              ]
          }
        end
        def self.true_case_for_check_name_availability
          {
              "nameAvailable"=> true,
              "reason"=> "AccountNameInvalid|AlreadyExists",
              "message"=> "error message"
          }
        end
        def self.false_case_for_check_name_availability
          {
              "nameAvailable"=> false,
              "reason"=> "AccountNameInvalid|AlreadyExists",
              "message"=> "error message"
          }
        end
        def self.azure_operation_response(body)
          MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new, Azure::ARM::Storage::Models::CheckNameAvailabilityResult.deserialize_object(body))
        end
      end
    end
  end
end