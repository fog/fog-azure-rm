module Fog
  module Compute
    class AzureRM
      # This class is giving implementation of create/save and
      # delete/destroy for Managed Disk.
      class ManagedDisk < Fog::Model
        attribute :id
        identity  :name
        attribute :type
        attribute :location
        attribute :resource_group_name
        # Either one of them is needed for disk creation, sku is new, account_type kept for
        # compatibility reasons
        attribute :sku
        attribute :account_type
        ##
        attribute :disk_size_gb
        attribute :owner_id
        attribute :provisioning_state
        attribute :tags
        attribute :time_created
        attribute :creation_data
        attribute :os_type
        attribute :encryption_settings_collection

        def self.parse(managed_disk)
          disk = get_hash_from_object(managed_disk)

          unless managed_disk.creation_data.nil?
            creation_data = Fog::Compute::AzureRM::CreationData.new
            disk['creation_data'] = creation_data.merge_attributes(Fog::Compute::AzureRM::CreationData.parse(managed_disk.creation_data))
          end

          unless managed_disk.encryption_settings_collection.nil?
            encryption_settings = Fog::Compute::AzureRM::EncryptionSettingsCollection.new
            disk['encryption_settings'] = encryption_settings.merge_attributes(Fog::Compute::AzureRM::EncryptionSettingsCollection.parse(managed_disk.encryption_settings))
          end

          disk['resource_group_name'] = get_resource_group_from_id(managed_disk.id)

          disk
        end

        def save
          requires :name, :location, :resource_group_name, :creation_data
          requires :disk_size_gb

          if self.sku.nil? && !self.account_type.nil?
            self.sku = {
              name: self.account_type
            }
          elsif self.account_type.nil? && self.sku.nil?
            raise(ArgumentError, 'Either account_type or sku is needed for this operation')
          end

          validate_creation_data_params(creation_data)
          disk = service.create_or_update_managed_disk(managed_disk_params)
          merge_attributes(Fog::Compute::AzureRM::ManagedDisk.parse(disk))
        end

        def destroy(async = false)
          response = service.delete_managed_disk(resource_group_name, name,
                                                 async)
          async ? create_fog_async_response(response) : response
        end

        def creation_data=(new_creation_data)
          attributes[:creation_data] =
            if new_creation_data.is_a?(Hash)
              creation_data = Fog::Compute::AzureRM::CreationData.new
              creation_data.merge_attributes(new_creation_data)
            else
              new_creation_data
            end
        end

        def ready?
          provisioning_state == "Succeeded"
        end

        private

        def validate_creation_data_params(creation_data)
          if !creation_data || creation_data.create_option.nil?
            raise(ArgumentError, 'creation_data.create_option is required for this operation')
          end
        end

        def managed_disk_params
          {
            name: name,
            location: location,
            resource_group_name: resource_group_name,
            sku: sku,
            os_type: os_type,
            disk_size_gb: disk_size_gb,
            tags: tags,
            creation_data: creation_data.attributes,
            encryption_settings: encryption_settings_collection
          }
        end

        def create_fog_async_response(response, delete_extra_resource = false)
          disk = Fog::Compute::AzureRM::ManagedDisk.new(service: service)
          Fog::AzureRM::AsyncResponse.new(disk, response, delete_extra_resource)
        end
      end
    end
  end
end
