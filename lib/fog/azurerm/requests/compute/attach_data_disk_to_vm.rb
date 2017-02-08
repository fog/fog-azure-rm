module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def attach_data_disk_to_vm(resource_group, vm_name, disk_name, disk_size, storage_account_name)
          msg = "Attaching Data Disk #{disk_name} to Virtual Machine #{vm_name} in Resource Group #{resource_group}"
          Fog::Logger.debug msg
          vm = get_virtual_machine_instance(resource_group, vm_name, @compute_mgmt_client)
          lun = get_logical_unit_number(vm.storage_profile.data_disks)
          access_key = get_storage_access_key(resource_group, storage_account_name, @storage_mgmt_client)
          data_disk = get_data_disk_object(disk_name, disk_size, lun, storage_account_name, access_key)
          vm.storage_profile.data_disks.push(data_disk)
          vm.resources = nil
          begin
            virtual_machine = @compute_mgmt_client.virtual_machines.create_or_update(resource_group, vm_name, vm)
          rescue MsRestAzure::AzureOperationError => e
            if e.body.to_s =~ /InvalidParameter/ && e.body.to_s =~ /already exists/
              Fog::Logger.debug 'The disk is already attached'
            else
            raise_azure_exception(e, msg)
            end
          end
          Fog::Logger.debug "Data Disk #{disk_name} attached to Virtual Machine #{vm_name} successfully."
          virtual_machine
        end

        private

        def get_virtual_machine_instance(resource_group, vm_name, client)
          msg = "Getting Virtual Machine #{vm_name} from Resource Group #{resource_group}"
          Fog::Logger.debug msg
          begin
            virtual_machine = client.virtual_machines.get(resource_group, vm_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Getting Virtual Machine #{vm_name} from Resource Group #{resource_group} successful"
          virtual_machine
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
          msg = "Getting Storage Access Keys from Resource Group #{resource_group}"
          Fog::Logger.debug msg
          begin
            storage_account_keys = storage_client.storage_accounts.list_keys(resource_group, storage_account_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Getting Storage Access Keys from Resource Group #{resource_group} successful"
          storage_account_keys.keys[0].value
        end

        def get_data_disk_object(disk_name, disk_size, lun, storage_account_name, access_key)
          data_disk = Azure::ARM::Compute::Models::DataDisk.new
          data_disk.name = disk_name
          data_disk.lun = lun
          data_disk.disk_size_gb = disk_size.to_s
          data_disk.vhd = Azure::ARM::Compute::Models::VirtualHardDisk.new
          data_disk.vhd.uri = "https://#{storage_account_name}.blob.core.windows.net/vhds/#{storage_account_name}-#{disk_name}.vhd"
          data_disk.caching = Azure::ARM::Compute::Models::CachingTypes::ReadWrite
          blob_name = "#{storage_account_name}-#{disk_name}.vhd"
          disk_exist = check_blob_exist(storage_account_name, blob_name, access_key)
          data_disk.create_option = Azure::ARM::Compute::Models::DiskCreateOptionTypes::Empty
          data_disk.create_option = Azure::ARM::Compute::Models::DiskCreateOptionTypes::Attach if disk_exist
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
            raise_azure_exception(e, 'Checking blob existence')
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def attach_data_disk_to_vm(*)
          vm = {
            'location' => 'West US',
            'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Compute/virtualMachines/fog-test-server',
            'name' => 'fog-test-server',
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
                        'name' => 'fog-test-server_os_disk',
                        'vhd' =>
                          {
                            'uri' => 'http://mystorage1.blob.core.windows.net/vhds/fog-test-server_os_disk.vhd'
                          },
                        'createOption' => 'FromImage',
                        'osType' => 'Linux',
                        'caching' => 'ReadWrite'
                      },
                    'dataDisks' => [{
                      'lun' => 0,
                      'name' => 'fog-test-server_data_disk',
                      'vhd_uri' => 'https://confizrg7443.blob.core.windows.net/vhds/fog-test-server_data_disk.vhd',
                      'create_option' => 'empty',
                      'disk_size_gb' => 1
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
                          'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Network/networkInterfaces/fog-test-vnet'
                        }
                      ]
                  },
                'provisioningState' => 'Succeeded'
              }
          }
          vm_mapper = Azure::ARM::Compute::Models::VirtualMachine.mapper
          @compute_mgmt_client.deserialize(vm_mapper, vm, 'result.body')
        end
      end
    end
  end
end
