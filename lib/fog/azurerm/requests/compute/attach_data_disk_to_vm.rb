module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def attach_data_disk_to_vm(resource_group, vm_name, disk_name, disk_size, storage_account_name)
          Fog::Logger.debug "Attaching Data Disk #{disk_name} to Virtual Machine #{vm_name} in Resource Group #{resource_group}."
          vm = get_virtual_machine_instance(resource_group, vm_name, @compute_mgmt_client)
          lun = get_logical_unit_number(vm.properties.storage_profile.data_disks)
          access_key = get_storage_access_key(resource_group, storage_account_name, @storage_mgmt_client)
          data_disk = build_storage_profile(disk_name, disk_size, lun, storage_account_name, access_key)
          vm.properties.storage_profile.data_disks.push(data_disk)
          vm.resources = nil
          begin
            promise = @compute_mgmt_client.virtual_machines.create_or_update(resource_group, vm_name, vm)
            result = promise.value!
            Fog::Logger.debug "Data Disk #{disk_name} attached to Virtual Machine #{vm_name} successfully."
            Azure::ARM::Compute::Models::VirtualMachine.serialize_object(result.body)
          rescue MsRestAzure::AzureOperationError => e
            msg = "Error Attaching Data Disk #{disk_name} to Virtual Machine #{vm_name} in Resource Group #{resource_group}. #{e.body['error']['message']}"
            raise msg
          end
        end

        private

        def get_virtual_machine_instance(resource_group, vm_name, client)
          begin
            promise = client.virtual_machines.get(resource_group, vm_name)
            result = promise.value!
            result.body
          rescue MsRestAzure::AzureOperationError => e
            msg = "Error Attaching Data Disk to Virtual Machine. #{e.body['error']['message']}"
            raise msg
          end
        end

        def get_logical_unit_number(data_disks)
          lun_range_list = (0..15).to_a
          data_disks.each do |disk|
            lun_range_list.delete(disk.lun)
          end

          if lun_range_list.empty?
            msg = 'Error Attaching Data Disk to Virtual Machine. No slot available.'
            raise msg
          end
          lun_range_list[0]
        end

        def get_storage_access_key(resource_group, storage_account_name, storage_client)
          begin
            storage_account_keys = storage_client.storage_accounts.list_keys(resource_group, storage_account_name).value!
            storage_account_keys.body.key2
          rescue MsRestAzure::AzureOperationError => e
            msg = "Error Attaching Data Disk to Virtual Machine. #{e.body['error']['message']}"
            raise msg
          end
        end

        def build_storage_profile(disk_name, disk_size, lun, storage_account_name, access_key)
          data_disk = Azure::ARM::Compute::Models::DataDisk.new
          data_disk.name = disk_name
          data_disk.lun = lun
          data_disk.disk_size_gb = disk_size.to_s
          data_disk.vhd = Azure::ARM::Compute::Models::VirtualHardDisk.new
          data_disk.vhd.uri = "https://#{storage_account_name}.blob.core.windows.net/vhds/#{disk_name}.vhd"
          data_disk.caching = Azure::ARM::Compute::Models::CachingTypes::ReadWrite
          blob_name = "#{disk_name}.vhd"
          is_new_disk_or_old = check_blob_exist(storage_account_name, blob_name, access_key)
          data_disk.create_option = if is_new_disk_or_old == true
                                      Azure::ARM::Compute::Models::DiskCreateOptionTypes::Attach
                                    else
                                      Azure::ARM::Compute::Models::DiskCreateOptionTypes::Empty
                                    end
          data_disk
        end

        def check_blob_exist(storage_account_name, blob_name, access_key)
          client = Azure::Storage::Client.new(storage_account_name: storage_account_name, storage_access_key: access_key)
          blob_service = Azure::Storage::Blob::BlobService.new(client: client)
          begin
            blob_prop = blob_service.get_blob_properties('vhds', blob_name)
            true unless blob_prop.nil?
          rescue Azure::Core::Http::HTTPError => e
            return false if e.status_code == 404
            msg = "Error Attaching Data Disk to Virtual Machine. #{e.description}"
            raise msg
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def attach_data_disk_to_vm(resource_group, vm_name, disk_name, disk_size, storage_account_name)
          {
            'location' => 'West US',
            'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Compute/virtualMachines/#{name}",
            'name' => vm_name,
            'type' => 'Microsoft.Compute/virtualMachines',
            'properties' =>
              {
                'hardwareProfile' =>
                  {
                    'vmSize' => 'Basic_A0'
                  },
                'storageProfile' =>
                  {
                    'imageReference' =>
                      {
                        'publisher' => 'Canonical',
                        'offer' => 'UbuntuServer',
                        'sku' => '14.04.2-LTS',
                        'version' => 'latest'
                      },
                    'osDisk' =>
                      {
                        'name' => "#{vm_name}_os_disk",
                        'vhd' =>
                          {
                            'uri' => "http://#{storage_account_name}.blob.core.windows.net/vhds/#{vm_name}_os_disk.vhd"
                          },
                        'createOption' => 'FromImage',
                        'osType' => 'Linux',
                        'caching' => 'ReadWrite'
                      },
                    'dataDisks' => [{
                      'lun' => 0,
                      'name' => disk_name,
                      'vhd_uri' => "https://confizrg7443.blob.core.windows.net/vhds/#{disk_name}.vhd",
                      'create_option' => 'empty',
                      'disk_size_gb' => disk_size
                    }]
                  },
                'osProfile' =>
                  {
                    'computerName' => 'fog',
                    'adminUsername' => 'Fog=123',
                    'linuxConfiguration' =>
                        {
                          'disablePasswordAuthentication' => true
                        },
                    'secrets' => []
                  },
                'networkProfile' =>
                  {
                    'networkInterfaces' =>
                      [
                        {
                          'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/networkInterfaces/fog-test-vnet"
                        }
                      ]
                  },
                'provisioningState' => 'Succeeded'
              }
          }
        end
      end
    end
  end
end
