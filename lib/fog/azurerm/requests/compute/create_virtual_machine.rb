require 'base64'
WHITE_SPACE = ' '.freeze

module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def create_virtual_machine(vm_config, async = false)
          msg = "Creating Virtual Machine #{vm_config[:name]} in Resource Group #{vm_config[:resource_group]}."
          Fog::Logger.debug msg
          virtual_machine = Azure::ARM::Compute::Models::VirtualMachine.new

          unless vm_config[:availability_set_id].nil?
            sub_resource = MsRestAzure::SubResource.new
            sub_resource.id = vm_config[:availability_set_id]
            virtual_machine.availability_set = sub_resource
          end

          string_data = vm_config[:custom_data]
          string_data = WHITE_SPACE if string_data.nil?
          encoded_data = Base64.strict_encode64(string_data)
          virtual_machine.hardware_profile = define_hardware_profile(vm_config[:vm_size])
          virtual_machine.storage_profile = define_storage_profile(vm_config[:name],
                                                                   vm_config[:storage_account_name],
                                                                   vm_config[:publisher],
                                                                   vm_config[:offer],
                                                                   vm_config[:sku],
                                                                   vm_config[:version],
                                                                   vm_config[:vhd_path],
                                                                   vm_config[:os_disk_caching],
                                                                   vm_config[:platform],
                                                                   vm_config[:resource_group],
                                                                   vm_config[:managed_disk_storage_type],
                                                                   vm_config[:os_disk_size],
                                                                   vm_config[:location])

          virtual_machine.os_profile = if vm_config[:platform].casecmp(WINDOWS).zero?
                                         define_windows_os_profile(vm_config[:name],
                                                                   vm_config[:username],
                                                                   vm_config[:password],
                                                                   vm_config[:provision_vm_agent],
                                                                   vm_config[:enable_automatic_updates],
                                                                   encoded_data)
                                       else
                                         define_linux_os_profile(vm_config[:name],
                                                                 vm_config[:username],
                                                                 vm_config[:password],
                                                                 vm_config[:disable_password_authentication],
                                                                 vm_config[:ssh_key_path],
                                                                 vm_config[:ssh_key_data],
                                                                 encoded_data)
                                       end
          virtual_machine.network_profile = define_network_profile(vm_config[:network_interface_card_ids])
          virtual_machine.location = vm_config[:location]
          virtual_machine.tags = vm_config[:tags]
          begin
            response = if async
                         @compute_mgmt_client.virtual_machines.create_or_update_async(vm_config[:resource_group], vm_config[:name], virtual_machine)
                       else
                         @compute_mgmt_client.virtual_machines.create_or_update(vm_config[:resource_group], vm_config[:name], virtual_machine)
                       end
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          unless async
            is_managed_custom_vm = !vm_config[:vhd_path].nil? && !vm_config[:managed_disk_storage_type].nil?
            if is_managed_custom_vm
              delete_generalized_image(vm_config[:resource_group], vm_config[:name])
              delete_storage_account_or_container(vm_config[:resource_group], vm_config[:storage_account_name], vm_config[:name])
            end
          end
          Fog::Logger.debug "Virtual Machine #{vm_config[:name]} Created Successfully." unless async
          response
        end

        private

        def define_hardware_profile(vm_size)
          hw_profile = Azure::ARM::Compute::Models::HardwareProfile.new
          hw_profile.vm_size = vm_size
          hw_profile
        end

        def image_reference(publisher, offer, sku, version)
          image_reference = Azure::ARM::Compute::Models::ImageReference.new
          image_reference.publisher = publisher
          image_reference.offer = offer
          image_reference.sku = sku
          image_reference.version = version
          image_reference
        end

        def define_storage_profile(vm_name, storage_account_name, publisher, offer, sku, version, vhd_path, os_disk_caching, platform, resource_group, managed_disk_storage_type, os_disk_size, location)
          storage_profile = Azure::ARM::Compute::Models::StorageProfile.new
          storage_profile.image_reference = image_reference(publisher, offer, sku, version) if vhd_path.nil?
          os_disk = Azure::ARM::Compute::Models::OSDisk.new

          new_vhd_path = copy_vhd_to_storage_account(resource_group, storage_account_name, vhd_path, location, vm_name) unless vhd_path.nil?

          if managed_disk_storage_type.nil?
            vhd = Azure::ARM::Compute::Models::VirtualHardDisk.new
            vhd.uri = get_blob_endpoint(storage_account_name) + "/vhds/#{vm_name}_os_disk.vhd"

            unless vhd_path.nil?
              img_vhd = Azure::ARM::Compute::Models::VirtualHardDisk.new
              img_vhd.uri = new_vhd_path
              os_disk.image = img_vhd
            end

            os_disk.vhd = vhd
          else
            unless vhd_path.nil?
              image_obj = create_generalized_image(image_config_params(location, new_vhd_path, platform, resource_group, vm_name))
              storage_profile.image_reference = Azure::ARM::Compute::Models::ImageReference.new
              storage_profile.image_reference.id = image_obj.id
            end

            managed_disk = Azure::ARM::Compute::Models::ManagedDiskParameters.new
            managed_disk.storage_account_type = managed_disk_storage_type
            os_disk.managed_disk = managed_disk
          end
          storage_profile.os_disk = configure_os_disk_object(os_disk, os_disk_caching, os_disk_size, platform, vm_name)
          storage_profile
        end

        def image_config_params(location, new_vhd_path, platform, resource_group, vm_name)
          {
            location: location,
            new_vhd_path: new_vhd_path,
            platform: platform,
            resource_group: resource_group,
            vm_name: vm_name
          }
        end

        def configure_os_disk_object(os_disk, os_disk_caching, os_disk_size, platform, vm_name)
          os_disk.name = "#{vm_name}_os_disk"
          os_disk.os_type = platform
          os_disk.disk_size_gb = os_disk_size unless os_disk_size.nil?
          os_disk.create_option = Azure::ARM::Compute::Models::DiskCreateOptionTypes::FromImage
          os_disk.caching = unless os_disk_caching.nil?
                              case os_disk_caching
                              when 'None'
                                Azure::ARM::Compute::Models::CachingTypes::None
                              when 'ReadOnly'
                                Azure::ARM::Compute::Models::CachingTypes::ReadOnly
                              when 'ReadWrite'
                                Azure::ARM::Compute::Models::CachingTypes::ReadWrite
                              end
                            end
          os_disk
        end

        def define_windows_os_profile(vm_name, username, password, provision_vm_agent, enable_automatic_updates, encoded_data)
          os_profile = Azure::ARM::Compute::Models::OSProfile.new
          windows_config = Azure::ARM::Compute::Models::WindowsConfiguration.new
          windows_config.provision_vmagent = provision_vm_agent
          windows_config.enable_automatic_updates = enable_automatic_updates
          os_profile.windows_configuration = windows_config
          os_profile.computer_name = vm_name
          os_profile.admin_username = username
          os_profile.admin_password = password
          os_profile.custom_data = encoded_data
          os_profile
        end

        def define_linux_os_profile(vm_name, username, password, disable_password_authentication, ssh_key_path, ssh_key_data, encoded_data)
          os_profile = Azure::ARM::Compute::Models::OSProfile.new
          linux_config = Azure::ARM::Compute::Models::LinuxConfiguration.new

          unless ssh_key_path.nil? || ssh_key_data.nil?
            ssh_config = Azure::ARM::Compute::Models::SshConfiguration.new
            ssh_public_key = Azure::ARM::Compute::Models::SshPublicKey.new
            ssh_public_key.path = ssh_key_path
            ssh_public_key.key_data = ssh_key_data
            ssh_config.public_keys = [ssh_public_key]
            linux_config.ssh = ssh_config
          end

          linux_config.disable_password_authentication = disable_password_authentication
          os_profile.linux_configuration = linux_config
          os_profile.computer_name = vm_name
          os_profile.admin_username = username
          os_profile.admin_password = password
          os_profile.custom_data = encoded_data
          os_profile
        end

        def copy_vhd_to_storage_account(resource_group, storage_account_name, vhd_path, location, vm_name)
          # Copy if VHD does not exist belongs to same storage account.
          vhd_storage_account = (vhd_path.split('/')[2]).split('.')[0]
          if storage_account_name != vhd_storage_account
            if storage_account_name.nil?
              new_time = current_time
              storage_account_name = "sa#{new_time}"
              storage_account = @storage_service.storage_accounts.create(
                storage_account_config_params(location, resource_group, storage_account_name)
              )
            else
              storage_account = @storage_service.storage_accounts.get(resource_group, storage_account_name)
            end
            access_key = storage_account.get_access_keys.first.value
            storage_data = Fog::Storage::AzureRM.new(azure_storage_account_name: storage_account_name, azure_storage_access_key: access_key)
            new_time = current_time
            container_name = "customvhd-#{vm_name.downcase}-os-image"
            blob_name = "vhd_image#{new_time}.vhd"
            storage_data.directories.create(key: container_name)
            storage_data.copy_blob_from_uri(container_name, blob_name, vhd_path)
            until storage_data.get_blob_properties(container_name, blob_name).properties[:copy_status] == 'success'
              Fog::Logger.debug 'Waiting disk to ready'
              sleep(10)
            end
            new_vhd_path = get_blob_endpoint(storage_account_name) + "/#{container_name}/#{blob_name}"
            Fog::Logger.debug "Path:#{new_vhd_path}. | Copy done"
          else
            new_vhd_path = vhd_path
          end
          new_vhd_path
        end

        def storage_account_config_params(location, resource_group, storage_account_name)
          {
            name: storage_account_name,
            location: location,
            resource_group: resource_group,
            account_type: 'Standard',
            replication: 'LRS',
            tags:
            {
              GENERALIZED_IMAGE_TAG_KEY => GENERALIZED_IMAGE_TAG_VALUE
            }
          }
        end

        def define_network_profile(network_interface_card_ids)
          network_interface_cards = []
          network_interface_card_ids.each_with_index do |id, index|
            nic = Azure::ARM::Compute::Models::NetworkInterfaceReference .new
            nic.id = id
            nic.primary = index == PRIMARY_NIC_INDEX
            network_interface_cards << nic
          end

          network_profile = Azure::ARM::Compute::Models::NetworkProfile.new
          network_profile.network_interfaces = network_interface_cards
          network_profile
        end

        def delete_storage_account_or_container(resource_group, storage_account_name, vm_name)
          delete_storage_account(resource_group) if storage_account_name.nil?
          delete_storage_container(resource_group, storage_account_name, vm_name) unless storage_account_name.nil?
        end

        def delete_storage_container(resource_group, storage_account_name, vm_name)
          access_key = @storage_service.get_storage_access_keys(resource_group, storage_account_name).first.value
          @storage_service.directories.delete_temporary_storage_container(storage_account_name, access_key, vm_name)
        end

        def delete_storage_account(resource_group)
          @storage_service.storage_accounts.delete_storage_account_from_tag(resource_group, GENERALIZED_IMAGE_TAG_KEY, GENERALIZED_IMAGE_TAG_VALUE)
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def create_virtual_machine(*)
          vm = {
            'location' => 'westus',
            'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Compute/virtualMachines/fog-test-server',
            'name' => 'fog-test-server',
            'type' => 'Microsoft.Compute/virtualMachines',
            'properties' =>
            {
              'hardwareProfile' =>
                {
                  'vmSize' => 'Standard_A0'
                },
              'storageProfile' =>
                {
                  'imageReference' =>
                    {
                      'publisher' => 'MicrosoftWindowsServerEssentials',
                      'offer' => 'WindowsServerEssentials',
                      'sku' => 'WindowsServerEssentials',
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
                  'dataDisks' => []
                },
              'osProfile' =>
                {
                  'computerName' => 'fog-test-server',
                  'adminUsername' => 'fog',
                  'linuxConfiguration' =>
                    {
                      'disablePasswordAuthentication' => true
                    },
                  'secrets' => [],
                  'customData' => 'ZWNobyBjdXN0b21EYXRh'
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
