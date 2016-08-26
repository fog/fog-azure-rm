module ApiStub
  module Models
    module Storage
      # Mock class for Data Disk Model
      class DataDisk
        def self.create_data_disk_response
          {
            'lun' => 0,
            'name' => 'disk1',
            'vhd' => {
              'uri' => 'https://confizrg7443.blob.core.windows.net/vhds/disk1.vhd'
            },
            'createOption' => 'empty',
            'diskSizeGB' => '10'
          }
        end

        def self.expected_create_data_disk_response
          {
              'name' => 'disk1',
              'disk_size_gb' => '10',
              'lun' => 0,
              'vhd_uri' => 'https://confizrg7443.blob.core.windows.net/vhds/disk1.vhd',
              'create_option' => 'empty'
          }
        end
      end
    end
  end
end
