module Fog
  module Storage
    class AzureRM
      # This class is giving implementation of create/save and
      # delete/destroy for storage account.
      class StorageAccount < Fog::Model
        identity  :name
        attribute :id
        attribute :location
        attribute :resource_group
        attribute :sku_name
        attribute :replication
        attribute :encryption

        def self.parse(storage_account)
          hash = {}
          hash['id'] = storage_account.id
          hash['name'] = storage_account.name
          hash['location'] = storage_account.location
          hash['resource_group'] = get_resource_group_from_id(storage_account.id)
          hash['sku_name'] = storage_account.sku.name.split('_').first
          hash['replication'] = storage_account.sku.name.split('_').last
          hash['encryption'] = storage_account.encryption.services.blob.enabled unless storage_account.encryption.nil?
          hash
        end

        def save
          requires :name
          requires :location
          requires :resource_group
          # Create a model for new storage account.
          self.sku_name = STANDARD_STORAGE if sku_name.nil?
          self.replication = ALLOWED_STANDARD_REPLICATION.first if replication.nil?
          validate_sku_name!
          storage_account = service.create_storage_account(storage_account_params)
          merge_attributes(Fog::Storage::AzureRM::StorageAccount.parse(storage_account))
        end

        def storage_account_params
          {
            resource_group: resource_group,
            name: name,
            sku_name: sku_name,
            location: location,
            replication: replication,
            encryption: encryption
          }
        end

        def update(storage_account_params)
          validate_input(storage_account_params)
          storage_account_params = merge_attributes(storage_account_params).all_attributes

          storage_account = service.update_storage_account(storage_account_params)
          merge_attributes(Fog::Storage::AzureRM::StorageAccount.parse(storage_account))
        end

        def validate_sku_name!
          case sku_name
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

        private

        def validate_input(attr_hash)
          invalid_attr = [:resource_group, :name, :location, :id]
          result = invalid_attr & attr_hash.keys
          raise 'Cannot modify the given attribute' unless result.empty?
        end

        private :storage_account_params, :validate_sku_name!
      end
    end
  end
end
