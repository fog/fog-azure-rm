module Fog
  module Compute
    class AzureRM
      # DataDisk Model for Compute Service
      class DataDisk < Fog::Model
        identity  :name
        attribute :disk_size_gb
        attribute :lun
        attribute :caching
        attribute :create_option
        # For these composite objects we ONLY need one field
        attribute :vhd_uri
        attribute :image_uri
        attribute :managed_disk_id

        def self.parse(disk)
          disk_hash = get_hash_from_object(disk)
          disk_hash['vhd_uri'] = disk.vhd.uri if disk.vhd
          disk_hash['image_uri'] = disk.image.uri if disk.image
          disk_hash['managed_disk_id'] = disk.managed_disk.id if disk.managed_disk
          disk_hash
        end
      end
    end
  end
end
