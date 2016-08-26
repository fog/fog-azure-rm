module Fog
  module Storage
    class AzureRM
      # DataDisk Model for Storage Service
      class DataDisk < Fog::Model
        identity  :name
        attribute :disk_size_gb
        attribute :lun
        attribute :vhd_uri
        attribute :caching
        attribute :create_option

        def self.parse(disk)
          hash = {}
          hash['name'] = disk.name
          hash['disk_size_gb'] = disk.disk_size_gb
          hash['lun'] = disk.lun
          hash['vhd_uri'] = disk.vhd.uri
          hash['caching'] = disk.caching unless disk.caching.nil?
          hash['create_option'] = disk.create_option
          hash
        end
      end
    end
  end
end
