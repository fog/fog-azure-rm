STANDARD = 'Standard'.freeze
PREMIUM = 'Premium'.freeze
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
          requires :account_type

          hash = {}
          # Create a model for new storage account.
          properties = Azure::ARM::Storage::Models::StorageAccountPropertiesCreateParameters.new
          validate_account_type!
          properties.account_type = "#{account_type}_LRS"
          params = Azure::ARM::Storage::Models::StorageAccountCreateParameters.new
          params.properties = properties
          params.location = location
          sa = service.create_storage_account(resource_group, name, params)
          hash['account_type'] = sa['properties']['accountType']
          merge_attributes(hash)
        end

        def validate_account_type!
          if account_type != STANDARD && account_type != PREMIUM
            msg = 'Account Type can only be Standard or Premium'
            raise msg
          end
        end

        def get_access_keys(options = {})
          service.get_storage_access_keys(resource_group, name, options)
        end

        def destroy
          service.delete_storage_account(resource_group, name)
        end
      end
    end
  end
end
