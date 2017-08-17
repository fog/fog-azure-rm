module ApiStub
  module Models
    module DataLakeStore
      # Mock class for Data Lake Store Account
      class DataLakeStoreAccount
        def self.create_data_lake_store_account_obj(data_lake_client)
          account = '{
            "id": "/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.DataLakeStore/accounts/fogtestdls",
            "name": "fogtestdls",
            "type": "Microsoft.DataLakeStore/accounts",
            "etag": "00000003-0000-0000-bd66-02b337a4d101",
            "location": "East US 2",
            "tags": {},
            "encryption_state": "Enabled",
            "resource_group": "fog-test-rg"
          }'
          account_mapper = Azure::ARM::DataLakeStore::Models::DataLakeStoreAccount.mapper
          data_lake_client.deserialize(account_mapper, JSON.load(account), 'result.body')
        end

        def self.update_data_lake_store_account_obj(data_lake_client)
          account = '{
            "firewall_state": "Enabled",
            "firewall_allow_azure_ips" :"Enabled",
            "new_tier: "Consumption"
          }'
          account_mapper = Azure::ARM::DataLakeStore::Models::DataLakeStoreAccountUpdateParameters.mapper
          data_lake_client.deserialize(account_mapper, JSON.load(account), 'result.body')
        end
      end
    end
  end
end
