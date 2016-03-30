require 'fog/core/collection'
require 'fog/azurerm/models/storage/storage_account'

module Fog
  module Storage
    class AzureRM
      class  StorageAccounts < Fog::Collection
        model Fog::Storage::AzureRM::StorageAccount
        attribute :resource_group_name
        def all
          requires :resource_group_name
          accounts = []
          hash_of_storage_accounts = service.list_storage_accounts(resource_group_name)
          hash_of_storage_accounts.each do |account|
            hash = {}
            account.instance_variables.each do |var|
              hash[var.to_s.delete('@')] = account.instance_variable_get(var)
            end
            accounts << hash
          end
          load(accounts)
        end
        def all
          accounts = []
          service.list_storage_accounts.each do |account|
            hash = {}
            account.instance_variables.each do |var|
              hash[var.to_s.delete('@')] = account.instance_variable_get(var)
            end
            accounts << hash
          end
          load(accounts)
        end


        def get(identity)
          all.find { |f| f.name == identity }
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
