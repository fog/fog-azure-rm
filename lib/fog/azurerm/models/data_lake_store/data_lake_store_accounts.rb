module Fog
  module DataLakeStore
    class AzureRM
      # This class is giving implementation of
      # all/get for Zones.
      class DataLakeStoreAccounts < Fog::Collection
        model DataLakeStoreAccount

        def all
          accounts = []
          service.list_data_lake_store_accounts.each do |account|
            accounts << DataLakeStoreAccount.parse(account)
          end
          load(accounts)
        end

        def get(resource_group, name)
          account = service.get_data_lake_store_account(resource_group, name)
          account_obj = DataLakeStoreAccount.new(service: service)
          account_obj.merge_attributes(DataLakeStoreAccount.parse(account))
        end

        def check_for_data_lake_store_account(resource_group, name)
          service.check_for_data_lake_store_account(resource_group, name)
        end
      end
    end
  end
end
