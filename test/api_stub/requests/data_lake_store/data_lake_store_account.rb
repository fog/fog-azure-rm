module ApiStub
  module Requests
    module DataLakeStore
      # Mock class for Data Lake Store Account
      class DataLakeStoreAccount
        def self.list_data_lake_store_accounts_response(data_lake_store_account_client)
          body = '{
            "value": [{
                       "id":"\/subscriptions\/########-####-####-####-############\/resourceGroups\/fog_test_rg\/providers\/Microsoft.DataLakeStore\/accounts\/fogtestdls",
                        "name":"fogtestdls",
                        "type":"Microsoft.DataLakeStore\/accounts",
                        "etag":"00000011-0000-0000-19f2-3a6c32b0d101",
                        "location":"East US 2",
                        "tags":{},
                        "properties":
                                    {
                                        "encryption_state":"Enabled"
                                    },
                        "resource_group":"fog-test-rg"
                        }]
            }'
          account_mapper = Azure::ARM::DataLakeStore::Models::DataLakeStoreAccountListResult.mapper
          data_lake_store_account_client.deserialize(account_mapper, JSON.load(body), 'result.body').value
        end

        def self.data_lake_store_account_response(data_lake_store_account_client)
          account = '{
            "id": "/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.DataLakeStore/accounts/fogtestdls",
            "name": "fogtestdls",
            "type": "Microsoft.DataLakeStore/accounts",
            "etag": "00000003-0000-0000-bd66-02b337a4d101",
            "location": "East US 2",
            "tags": {},
            "properties":
              {
                "encryption_state": "Enabled"
              },
            "resource_group": "fog-test-rg"
          }'
          account_mapper = Azure::ARM::DataLakeStore::Models::DataLakeStoreAccount.mapper
          data_lake_store_account_client.deserialize(account_mapper, JSON.load(account), 'result.body')
        end
      end
    end
  end
end
