module Fog
  module Compute
    class AzureRM
      # This class is giving implementation of create/save and
      # delete/destroy for snapshot.
      class Snapshot < Fog::Model
        attribute :id
        identity  :name
        attribute :location
        attribute :resource_group_name
        attribute :account_type
        attribute :disk_size_gb
        attribute :tags
        attribute :time_created
        attribute :creation_data
        attribute :encryption_settings
        attribute :type
        attribute :owner_id
        attribute :provisioning_state
        attribute :os_type

        def self.parse(snapshot)
          snap = get_hash_from_object(snapshot)

          snap['creation_data'] = parse_creation_data(snapshot.creation_data) unless snapshot.creation_data.nil?

          snap['encryption_settings'] = parse_encryption_settings_object(snapshot.encryption_settings) unless snapshot.encryption_settings.nil?

          snap['resource_group_name'] = get_resource_group_from_id(snapshot.id)

          snap
        end

        def destroy(async = false)
          service.delete_snapshot(resource_group_name, name, async)
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

        def self.parse_creation_data(azure_sdk_creation_data)
          creation_data = Fog::Compute::AzureRM::CreationData.new
          creation_data.merge_attributes(Fog::Compute::AzureRM::CreationData.parse(azure_sdk_creation_data))
        end

        def self.parse_encryption_settings_object(azure_sdk_encryption_settings)
          encryption_settings = Fog::Compute::AzureRM::EncryptionSettings.new
          encryption_settings.merge_attributes(Fog::Compute::AzureRM::EncryptionSettings.parse(azure_sdk_encryption_settings))
        end

        private_class_method :parse_creation_data, :parse_encryption_settings_object
      end
    end
  end
end
