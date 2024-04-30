module Fog
  module Compute
    class AzureRM
      class Image < Fog::Model
        attribute :id
        identity :name
        attribute :resource_group_name
        attribute :location
        attribute :provisioning_state
        attribute :source_server_id
        attribute :source_server_name
        attribute :managed_disk_id
        attribute :os_disk_size
        attribute :os_disk_state
        attribute :os_disk_type
        attribute :os_disk_caching
        attribute :os_disk_blob_uri
        attribute :tags

        def self.parse(image)
          hash = get_hash_from_object(image)
          hash['resource_group_name'] = get_resource_group_from_id(image.id)

          unless image.source_virtual_machine.nil?
            hash['source_server_id'] = image.source_virtual_machine.id
            hash['source_server_name'] = get_virtual_machine_from_id(image.source_virtual_machine.id)
          end

          unless image.storage_profile.nil?
            hash['os_disk_size'] = image.storage_profile.os_disk.disk_size_gb
            hash['os_disk_state'] = image.storage_profile.os_disk.os_state
            hash['os_disk_type'] = image.storage_profile.os_disk.os_type
            hash['os_disk_caching'] = image.storage_profile.os_disk.caching

            unless image.storage_profile.os_disk.blob_uri.nil?
              hash['os_disk_blob_uri'] = image.storage_profile.os_disk.blob_uri
            end

            unless image.storage_profile.os_disk.managed_disk.nil?
              hash['managed_disk_id'] = image.storage_profile.os_disk.managed_disk.id
            end
          end

          hash['tags'] ||= {}

          hash
        end

        def save
          requires :name, :location, :resource_group_name

          image = service.create_image(image_params)
          merge_attributes(Fog::Compute::AzureRM::Image.parse(image))
        end

        def destroy
          service.delete_image(resource_group_name, name)
        end

        private

        def image_params
          {
            name: name,
            location: location,
            resource_group: resource_group_name,
            source_virtual_machine_id: source_server_id,
            platform: os_disk_type,
            managed_disk_id: managed_disk_id,
            # kept for backward compatibility
            vm_name: source_server_name
          }
        end
      end
    end
  end
end
