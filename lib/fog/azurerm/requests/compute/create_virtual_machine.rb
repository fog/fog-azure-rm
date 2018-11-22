require 'base64'

WHITE_SPACE = ' '.freeze

module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def create_virtual_machine(vm_config, async = false)
          vm_name = vm_config[:name]
          rg_name = vm_config[:resource_group]

          # In case of updating the VM, we check if the user has passed any value for os_disk_name
          # If the user has not passed any value, we try to retrieve the value of os_disk_name from the VM
          # If the VM exists then the os_disk_name is retrieved; else it remains nil
          os_disk_parameters = get_os_disk_parameters(rg_name, vm_name) if vm_config[:os_disk_name].nil? || vm_config[:os_disk_vhd_uri].nil?
          vm_config[:os_disk_name] = os_disk_parameters[:os_disk_name] if vm_config[:os_disk_name].nil?
          vm_config[:os_disk_vhd_uri] = os_disk_parameters[:os_disk_vhd_uri] if vm_config[:os_disk_vhd_uri].nil?

          msg = "Creating Virtual Machine '#{vm_name}' in Resource Group '#{rg_name}'..."
          Fog::Logger.debug msg

          vm = Azure::Compute::Profiles::Latest::Mgmt::Models::VirtualMachine.new
          vm.location = vm_config[:location]
          vm.tags = vm_config[:tags]
          vm.availability_set = get_vm_availability_set(vm_config[:availability_set_id])
          vm.hardware_profile = get_hardware_profile(vm_config[:vm_size])
          vm.os_profile = get_os_profile(vm_config)
          vm.network_profile = get_network_profile(vm_config[:network_interface_card_ids])
          vm.storage_profile = get_storage_profile(vm_config)

          begin
            response = if async
                         @compute_mgmt_client.virtual_machines.create_or_update_async(rg_name, vm_name, vm)
                       else
                         @compute_mgmt_client.virtual_machines.create_or_update(rg_name, vm_name, vm)
                       end
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end

          unless async
            unless vm_config[:vhd_path].nil? || vm_config[:managed_disk_storage_type].nil?
              delete_image(rg_name, vm_name)
              delete_storage_account_or_container(rg_name, vm_config[:storage_account_name], vm_name)
            end
          end

          Fog::Logger.debug "Virtual Machine #{vm_name} created successfully!" unless async
          response
        end

        private

        def get_vm_availability_set(availability_set_id)
          sub_resource = nil
          unless availability_set_id.nil?
            sub_resource = MsRestAzure::SubResource.new
            sub_resource.id = availability_set_id
          end
          sub_resource
        end

        def get_hardware_profile(vm_size)
          hw_profile = Azure::Compute::Profiles::Latest::Mgmt::Models::HardwareProfile.new
          hw_profile.vm_size = vm_size
          hw_profile
        end

        def get_os_profile(vm_config)
          # Arguments unpacking
          platform = vm_config[:platform]
          vm_name = vm_config[:name]
          username = vm_config[:username]
          password = vm_config[:password]
          custom_data = vm_config[:custom_data] unless vm_config[:custom_data].nil?
          provision_vm_agent = vm_config[:provision_vm_agent]
          enable_automatic_updates = vm_config[:enable_automatic_updates]
          disable_password_auth = vm_config[:disable_password_authentication]
          ssh_key_path = vm_config[:ssh_key_path]
          ssh_key_data = vm_config[:ssh_key_data]

          # Build and return os profile object
          os_profile = Azure::Compute::Profiles::Latest::Mgmt::Models::OSProfile.new
          os_profile.computer_name = vm_name
          os_profile.admin_username = username
          os_profile.admin_password = password
          os_profile.custom_data = Base64.strict_encode64(custom_data) unless vm_config[:custom_data].nil?

          if platform.casecmp(WINDOWS).zero?
            os_profile.windows_configuration = get_windows_config(provision_vm_agent, enable_automatic_updates)
          else
            os_profile.linux_configuration = get_linux_config(disable_password_auth, ssh_key_path, ssh_key_data)
          end

          os_profile
        end

        def get_windows_config(provision_vm_agent, enable_automatic_updates)
          windows_config = Azure::Compute::Profiles::Latest::Mgmt::Models::WindowsConfiguration.new
          windows_config.provision_vmagent = provision_vm_agent
          windows_config.enable_automatic_updates = enable_automatic_updates
          windows_config
        end

        def get_linux_config(disable_password_auth, ssh_key_path, ssh_key_data)
          linux_config = Azure::Compute::Profiles::Latest::Mgmt::Models::LinuxConfiguration.new
          linux_config.disable_password_authentication = disable_password_auth

          unless ssh_key_path.nil? || ssh_key_data.nil?
            ssh_config = Azure::Compute::Profiles::Latest::Mgmt::Models::SshConfiguration.new
            ssh_public_key = Azure::Compute::Profiles::Latest::Mgmt::Models::SshPublicKey.new
            ssh_public_key.path = ssh_key_path
            ssh_public_key.key_data = ssh_key_data
            ssh_config.public_keys = [ssh_public_key]
            linux_config.ssh = ssh_config
          end

          linux_config
        end

        def get_network_profile(network_interface_card_ids)
          network_interface_cards = []
          network_interface_card_ids.each_with_index do |id, index|
            nic = Azure::Compute::Profiles::Latest::Mgmt::Models::NetworkInterfaceReference.new
            nic.id = id
            nic.primary = index == PRIMARY_NIC_INDEX
            network_interface_cards << nic
          end

          network_profile = Azure::Compute::Profiles::Latest::Mgmt::Models::NetworkProfile.new
          network_profile.network_interfaces = network_interface_cards
          network_profile
        end

        def get_storage_profile(vm_config)
          # Arguments unpacking
          managed_disk_storage_type = vm_config[:managed_disk_storage_type]

          storage_profile = if managed_disk_storage_type.nil?
                              get_unmanaged_vm_storage_profile(vm_config)
                            else
                              get_managed_vm_storage_profile(vm_config)
                            end
          storage_profile
        end

        def get_unmanaged_vm_storage_profile(vm_config)
          # Arguments unpacking
          vm_name = vm_config[:name]
          storage_account_name = vm_config[:storage_account_name]
          publisher = vm_config[:publisher]
          offer = vm_config[:offer]
          sku = vm_config[:sku]
          version = vm_config[:version]
          vhd_path = vm_config[:vhd_path]
          os_disk_caching = vm_config[:os_disk_caching]
          platform = vm_config[:platform]
          resource_group = vm_config[:resource_group]
          os_disk_size = vm_config[:os_disk_size]
          location = vm_config[:location]
          image_ref = vm_config[:image_ref]
          os_disk_name = vm_config[:os_disk_name]
          os_disk_vhd_uri = vm_config[:os_disk_vhd_uri]

          storage_profile = Azure::Compute::Profiles::Latest::Mgmt::Models::StorageProfile.new
          # Set OS disk VHD path
          os_disk = Azure::Compute::Profiles::Latest::Mgmt::Models::OSDisk.new
          vhd = Azure::Compute::Profiles::Latest::Mgmt::Models::VirtualHardDisk.new
          vhd.uri = os_disk_vhd_uri.nil? ? get_blob_endpoint(storage_account_name) + "/vhds/#{vm_name}_os_disk.vhd" : os_disk_vhd_uri
          os_disk.vhd = vhd

          if vhd_path.nil? && image_ref.nil?
            # Marketplace
            storage_profile.image_reference = image_reference(publisher, offer, sku, version)
          elsif !vhd_path.nil? && image_ref.nil?
            # VHD
            new_vhd_path = copy_vhd_to_storage_account(resource_group, storage_account_name, vhd_path, location, vm_name)
            img_vhd = Azure::Compute::Profiles::Latest::Mgmt::Models::VirtualHardDisk.new
            img_vhd.uri = new_vhd_path
            os_disk.image = img_vhd
          else
            # Image
            image_resource_group = get_resource_group_from_id(image_ref)
            image_name = get_image_name(image_ref)
            image = get_image(image_resource_group, image_name)
            storage_profile.image_reference = Azure::Compute::Profiles::Latest::Mgmt::Models::ImageReference.new
            storage_profile.image_reference.id = image.id
          end

          storage_profile.os_disk = configure_os_disk_object(os_disk, os_disk_name, os_disk_caching, os_disk_size, platform, vm_name)
          storage_profile
        end

        def get_managed_vm_storage_profile(vm_config)
          # Argument unpacking
          managed_disk_storage_type = vm_config[:managed_disk_storage_type]
          vhd_path = vm_config[:vhd_path]
          resource_group = vm_config[:resource_group]
          storage_account_name = vm_config[:storage_account_name]
          location = vm_config[:location]
          publisher = vm_config[:publisher]
          offer = vm_config[:offer]
          sku = vm_config[:sku]
          version = vm_config[:version]
          os_disk_caching = vm_config[:os_disk_caching]
          os_disk_size = vm_config[:os_disk_size]
          platform = vm_config[:platform]
          vm_name = vm_config[:name]
          image_ref = vm_config[:image_ref]
          os_disk_name = vm_config[:os_disk_name]

          # Build storage profile
          storage_profile = Azure::Compute::Profiles::Latest::Mgmt::Models::StorageProfile.new
          os_disk = Azure::Compute::Profiles::Latest::Mgmt::Models::OSDisk.new
          managed_disk = Azure::Compute::Profiles::Latest::Mgmt::Models::ManagedDiskParameters.new
          managed_disk.storage_account_type = managed_disk_storage_type
          os_disk.managed_disk = managed_disk

          if vhd_path.nil? && image_ref.nil?
            # Marketplace
            storage_profile.image_reference = image_reference(publisher, offer, sku, version)
          elsif !vhd_path.nil? && image_ref.nil?
            # VHD
            new_vhd_path = copy_vhd_to_storage_account(resource_group, storage_account_name, vhd_path, location, vm_name)
            image = create_image(image_config_params(location, new_vhd_path, platform, resource_group, vm_name))
            storage_profile.image_reference = Azure::Compute::Profiles::Latest::Mgmt::Models::ImageReference.new
            storage_profile.image_reference.id = image.id
          else
            # Image
            image_resource_group = get_resource_group_from_id(image_ref)
            image_name = get_image_name(image_ref)
            image = get_image(image_resource_group, image_name)
            storage_profile.image_reference = Azure::Compute::Profiles::Latest::Mgmt::Models::ImageReference.new
            storage_profile.image_reference.id = image.id
          end

          storage_profile.os_disk = configure_os_disk_object(os_disk, os_disk_name, os_disk_caching, os_disk_size, platform, vm_name)
          storage_profile
        end

        def image_reference(publisher, offer, sku, version)
          image_reference = Azure::Compute::Profiles::Latest::Mgmt::Models::ImageReference.new
          image_reference.publisher = publisher
          image_reference.offer = offer
          image_reference.sku = sku
          image_reference.version = version
          image_reference
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

        def configure_os_disk_object(os_disk, os_disk_name, os_disk_caching, os_disk_size, platform, vm_name)
          # It will use the os_disk_name provided or it will generate a name for itself if it is nil
          os_disk.name = os_disk_name.nil? ? "#{vm_name}_os_disk" : os_disk_name
          os_disk.os_type = platform
          os_disk.disk_size_gb = os_disk_size unless os_disk_size.nil?
          os_disk.create_option = Azure::Compute::Profiles::Latest::Mgmt::Models::DiskCreateOptionTypes::FromImage
          os_disk.caching = unless os_disk_caching.nil?
                              case os_disk_caching
                              when 'None'
                                Azure::Compute::Profiles::Latest::Mgmt::Models::CachingTypes::None
                              when 'ReadOnly'
                                Azure::Compute::Profiles::Latest::Mgmt::Models::CachingTypes::ReadOnly
                              when 'ReadWrite'
                                Azure::Compute::Profiles::Latest::Mgmt::Models::CachingTypes::ReadWrite
                              end
                            end
          os_disk
        end

        def copy_vhd_to_storage_account(resource_group, storage_account_name, vhd_path, location, vm_name)
          # Copy if VHD does not exist belongs to same storage account.
          vhd_storage_account_name = (vhd_path.split('/')[2]).split('.')[0]
          if storage_account_name != vhd_storage_account_name
            if storage_account_name.nil?
              new_time = current_time
              storage_account_name = "sa#{new_time}"
              storage_account_config = storage_account_config_params(location, resource_group, storage_account_name)
              storage_account = @storage_service.storage_accounts.create(storage_account_config)
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
              TEMPORARY_STORAGE_ACCOUNT_TAG_KEY => TEMPORARY_STORAGE_ACCOUNT_TAG_VALUE
            }
          }
        end

        def delete_storage_account_or_container(resource_group, storage_account_name, vm_name)
          delete_storage_account(resource_group) if storage_account_name.nil?
          delete_storage_container(resource_group, storage_account_name, vm_name) unless storage_account_name.nil?
        end

        def delete_storage_container(resource_group, storage_account_name, vm_name)
          access_key = @storage_service.get_storage_access_keys(resource_group, storage_account_name).first.value
          container_name = "customvhd-#{vm_name.downcase}-os-image"
          @storage_service.directories.delete_temporary_container(storage_account_name, access_key, container_name)
        end

        def delete_storage_account(resource_group)
          @storage_service.storage_accounts.delete_storage_account_from_tag(resource_group,
                                                                            TEMPORARY_STORAGE_ACCOUNT_TAG_KEY,
                                                                            TEMPORARY_STORAGE_ACCOUNT_TAG_VALUE)
        end

        def get_os_disk_parameters(resource_group, virtual_machine_name)
          os_disk_parameters = {}

          begin
            vm = get_virtual_machine(resource_group, virtual_machine_name, false)
          rescue
            return os_disk_parameters
          end

          unless vm.storage_profile.nil?
            os_disk_parameters[:os_disk_name] = vm.storage_profile.os_disk.name
            os_disk_parameters[:os_disk_vhd_uri] = vm.storage_profile.os_disk.vhd.uri unless vm.storage_profile.os_disk.vhd.nil?
          end

          os_disk_parameters
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

          vm_mapper = Azure::Compute::Profiles::Latest::Mgmt::Models::VirtualMachine.mapper
          @compute_mgmt_client.deserialize(vm_mapper, vm, 'result.body')
        end
      end
    end
  end
end
