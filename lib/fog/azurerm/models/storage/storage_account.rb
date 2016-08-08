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
          requires :account_type
          requires :replication

          hash = {}
          # Create a model for new storage account.
          validate_account_type!
          storage_account = service.create_storage_account(resource_group, name, account_type, location, replication)
          hash['account_type'] = storage_account['properties']['accountType']
          merge_attributes(hash)
        end

        def validate_account_type!
          case account_type
          when STANDARD
            if replication != 'LRS' && replication != 'ZRS' && replication != 'GRS' && replication != 'RAGRS'
              raise 'Standard Replications can only be LRS, ZRS, GRS or RAGRS.'
            end
          when PREMIUM
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
      end
    end
  end
end
