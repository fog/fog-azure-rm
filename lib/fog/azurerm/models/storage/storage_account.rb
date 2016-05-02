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
          service.create_storage_account(resource_group, name, params)
        end

        def destroy
          service.delete_storage_account(resource_group, name)
        end
      end
    end
  end
end
