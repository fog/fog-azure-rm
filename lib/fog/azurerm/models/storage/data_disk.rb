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

        def self.parse(vm)
          hash = {}
          hash['name'] = vm['name']
          hash['disk_size_gb'] = vm['diskSizeGB']
          hash['lun'] = vm['lun']
          hash['vhd_uri'] = vm['vhd']['uri']
          hash['caching'] = vm['caching'] unless vm['caching'].nil?
          hash['create_option'] = vm['createOption']
          hash
        end
      end
    end
  end
end
