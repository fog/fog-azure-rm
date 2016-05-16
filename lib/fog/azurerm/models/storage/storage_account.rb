# rubocop:disable LineLength
# rubocop:disable MethodLength
module Fog
  module Storage
    class AzureRM
      # This class is giving implementation of create/save and
      # delete/destroy for storage account.
      class StorageAccount < Fog::Model
        attribute :id
        identity  :name
        attribute :type
        attribute :location
        attribute :tags
        attribute :resource_group
        attribute :properties

        def self.parse(storaqe_account)
          hash = {}
          hash['id'] = storaqe_account['id']
          hash['name'] = storaqe_account['name']
          hash['type'] = storaqe_account['type']
          hash['location'] = storaqe_account['location']
          hash['tags'] = storaqe_account['tags']
          hash['resource_group'] = storaqe_account['resource_group']
          hash['properties'] = storaqe_account['properties']
          hash
        end

        def save
          requires :name
          requires :location
          requires :resource_group
          # Create a model for new storage account.
          properties = Azure::ARM::Storage::Models::StorageAccountPropertiesCreateParameters.new
          properties.account_type = 'Standard_LRS' # This might change in the near future!

          params = Azure::ARM::Storage::Models::StorageAccountCreateParameters.new
          params.properties = properties
          params.location = location
          storage_acc = service.create_storage_account(resource_group, name, params)
          puts "Storage account: #{storage_acc.inspect}"
          merge_attributes(Fog::Storage::AzureRM::StorageAccount.parse(storage_acc))
        end

        def destroy
          service.delete_storage_account(resource_group, name)
        end
      end
    end
  end
end
