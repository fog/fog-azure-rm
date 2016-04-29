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
          Fog::Logger.debug "Creating Storage Account: #{name}."
          # Create a model for new storage account.
          properties = Azure::ARM::Storage::Models::StorageAccountPropertiesCreateParameters.new
          properties.account_type = 'Standard_LRS' # This might change in the near future!

          params = Azure::ARM::Storage::Models::StorageAccountCreateParameters.new
          params.properties = properties
          params.location = location
          response = service.create_storage_account(resource_group, name, params)
          Fog::Logger.debug "Storage Account created successfully."
          response
        end

        def destroy
          Fog::Logger.debug "Deleting Storage Account: #{name}."
          service.delete_storage_account(resource_group, name)
          Fog::Logger.debug "Storage Account #{name} deleted successfully."
        end
      end
    end
  end
end
