module Fog
  module Storage
    class AzureRM
      # This class is giving implementation of create/save and
      # delete/destroy for storage account.
      class StorageAccount < Fog::Model
        identity  :name
        attribute :location
        attribute :resource_group
        attribute :account_type

        def save
          requires :name
          requires :location
          requires :resource_group
          hash = {}
          # Create a model for new storage account.
          properties = Azure::ARM::Storage::Models::StorageAccountPropertiesCreateParameters.new
          properties.account_type = 'Standard_LRS' # This might change in the near future!

          params = Azure::ARM::Storage::Models::StorageAccountCreateParameters.new
          params.properties = properties
          params.location = location
          sa = service.create_storage_account(resource_group, name, params)
          hash['account_type'] = sa['properties']['accountType']
          merge_attributes(hash)
        end

        def destroy
          service.delete_storage_account(resource_group, name)
        end
      end
    end
  end
end
