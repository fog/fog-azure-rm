module Fog
  module Storage
    class AzureRM
      class StorageAccount < Fog::Model
        identity :name
        attribute :location
        attribute :resource_group_name

        def save
          requires :name
          requires :location
          requires :resource_group_name
          puts "Creating Storage Account: #{name}."
          # Create a model for new storage account.
          properties = Azure::ARM::Storage::Models::StorageAccountPropertiesCreateParameters.new
          properties.account_type = 'Standard_LRS'  # This might change in the near future!

          params = Azure::ARM::Storage::Models::StorageAccountCreateParameters.new
          params.properties = properties
          params.location = location
          promise =  service.create_storage_account(resource_group_name, name, params)
          response = promise.value!
          result = response.body
          puts "Storage Account #{result.name} created successfully."
        end

        def destroy
          puts "Deleting Storage Account: #{name}."
          promise = service.delete_storage_account(resource_group_name, name)
          promise.value!
          puts "Storage Account #{name} deleted successfully."
        end

      end
    end
  end
end
