require 'fog/core/collection'
require 'fog/azurerm/models/storage/storage_account'

module Fog
  module Storage
    class AzureRM
      # This class is giving implementation of all/list, get and
      # check name availability for storage account.
      class StorageAccounts < Fog::Collection
        model Fog::Storage::AzureRM::StorageAccount
        attribute :resource_group
        def all
          accounts = []
          if !resource_group.nil?
            requires :resource_group
            hash_of_storage_accounts = service.list_storage_account_for_rg(resource_group)
          else
            hash_of_storage_accounts = service.list_storage_accounts
          end
          hash_of_storage_accounts.each do |account|
            accounts << Fog::Storage::AzureRM::StorageAccount.parse(account)
          end
          load(accounts)
        end

        def get(resource_group_name, storage_account_name)
          storage_account = service.get_storage_account(resource_group_name, storage_account_name)
          storage_account_object = Fog::Storage::AzureRM::StorageAccount.new(service: service)
          storage_account_object.merge_attributes(Fog::Storage::AzureRM::StorageAccount.parse(storage_account))
        end

        def check_name_availability(name)
          params = Azure::ARM::Storage::Models::StorageAccountCheckNameAvailabilityParameters.new
          params.name = name
          params.type = 'Microsoft.Storage/storageAccounts'
          service.check_storage_account_name_availability(params)
        end
      end
    end
  end
end
