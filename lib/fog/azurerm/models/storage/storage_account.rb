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
        attribute :replication

        def save
          requires :name
          requires :location
          requires :resource_group

          hash = {}
          # Create a model for new storage account.
          self.account_type = STANDARD_STORAGE if account_type.nil?
          self.replication = ALLOWED_STANDARD_REPLICATION.first if replication.nil?
          validate_account_type!
          storage_account_arguments = get_storage_account_arguments
          storage_account = service.create_storage_account(storage_account_arguments)
          hash['account_type'] = storage_account['properties']['accountType']
          merge_attributes(hash)
        end

        def get_storage_account_arguments
          {
            resource_group: resource_group,
            name: name,
            account_type: account_type,
            location: location,
            replication: replication
          }
        end

        def validate_account_type!
          case account_type
          when STANDARD_STORAGE
            raise 'Standard Replications can only be LRS, ZRS, GRS or RAGRS.' unless ALLOWED_STANDARD_REPLICATION.include?(replication)
          when PREMIUM_STORAGE
            raise 'Premium Replication can only be LRS.' if replication != 'LRS'
          else
            raise 'Account Type can only be Standard or Premium'
          end
        end

        def get_access_keys(options = {})
          service.get_storage_access_keys(resource_group, name, options)
        end

        def destroy
          service.delete_storage_account(resource_group, name)
        end

        private :get_storage_account_arguments, :validate_account_type!
      end
    end
  end
end
