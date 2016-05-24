module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def create_virtual_machine(resource_group, name, location, vm_size, storage_account_name,
                                   username, password, disable_password_authentication,
                                   ssh_key_path, ssh_key_data, network_interface_card_id,
                                   availability_set_id, publisher, offer, sku, version)
          Fog::Logger.debug "Creating Virtual Machine #{name} in Resource Group #{resource_group}."
          params = Azure::ARM::Compute::Models::VirtualMachine.new
          vm_properties = Azure::ARM::Compute::Models::VirtualMachineProperties.new

          unless availability_set_id.nil?
            sub_resource = MsRestAzure::SubResource.new
            sub_resource.id = availability_set_id
            vm_properties.availability_set = sub_resource
          end

          vm_properties.hardware_profile = define_hardware_profile(vm_size)
          vm_properties.storage_profile = define_storage_profile(name, storage_account_name, publisher, offer, sku, version)
          vm_properties.os_profile = define_os_profile(name, username, password, disable_password_authentication, ssh_key_path, ssh_key_data)
          vm_properties.network_profile = define_network_profile(network_interface_card_id)
          params.properties = vm_properties
          params.location = location
          begin
            promise = @compute_mgmt_client.virtual_machines.create_or_update(resource_group, name, params)
            result = promise.value!
            Fog::Logger.debug "Virtual Machine #{name} Created Successfully."
            Azure::ARM::Compute::Models::VirtualMachine.serialize_object(result.body)
          rescue MsRestAzure::AzureOperationError => e
            msg = "Error Creating Virtual Machine '#{name}' in Resource Group '#{resource_group}'. #{e.body['error']['message']}"
            raise msg
          end
        end

        private

        def define_hardware_profile(vm_size)
          hw_profile =  Azure::ARM::Compute::Models::HardwareProfile.new
          hw_profile.vm_size = vm_size
          hw_profile
        end

        def define_storage_profile(vm_name, storage_account_name, publisher, offer, sku, version)
          storage_profile = Azure::ARM::Compute::Models::StorageProfile.new
          os_disk = Azure::ARM::Compute::Models::OSDisk.new
          vhd = Azure::ARM::Compute::Models::VirtualHardDisk.new
          image_reference = Azure::ARM::Compute::Models::ImageReference.new

          image_reference.publisher = publisher
          image_reference.offer = offer
          image_reference.sku = sku
          image_reference.version = version
          vhd.uri = "http://#{storage_account_name}.blob.core.windows.net/vhds/#{vm_name}_os_disk.vhd"
          os_disk.name = "#{vm_name}_os_disk"
          os_disk.vhd = vhd
          os_disk.create_option = Azure::ARM::Compute::Models::DiskCreateOptionTypes::FromImage
          storage_profile.image_reference = image_reference
          storage_profile.os_disk = os_disk
          storage_profile
        end

        def define_os_profile(vm_name, username, password, disable_password_authentication, ssh_key_path, ssh_key_data)
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
          os_profile
        end

        def define_network_profile(network_interface_card_id)
          network_profile = Azure::ARM::Compute::Models::NetworkProfile.new
          nic = Azure::ARM::Compute::Models::NetworkInterfaceReference .new
          nic.id = network_interface_card_id
          network_profile.network_interfaces = [nic]
          network_profile
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def create_virtual_machine(resource_group, name, location, vm_size, storage_account_name,
                                   username, password, disable_password_authentication,
                                   ssh_key_path, ssh_key_data, network_interface_card_id,
                                   availability_set_id, publisher, offer, sku, version)
          {
            "location"=>location,
            "id"=>"/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Compute/virtualMachines/#{name}",
            "name"=>name,
            "type"=>"Microsoft.Compute/virtualMachines",
            "properties"=>
              {
                "hardwareProfile"=>
                  {
                    "vmSize"=>vm_size
                  },
                "storageProfile"=>
                  {
                    "imageReference"=>
                      {
                        "publisher"=>publisher,
                        "offer"=>offer,
                        "sku"=>sku,
                        "version"=>version
                      },
                    "osDisk"=>
                      {
                        "name"=>"#{name}_os_disk",
                        "vhd"=>
                          {
                            "uri"=>"http://#{storage_account_name}.blob.core.windows.net/vhds/#{name}_os_disk.vhd"
                          },
                        "createOption"=>"FromImage",
                        "osType"=>"Linux",
                        "caching"=>"ReadWrite"
                      },
                    "dataDisks"=>[]
                  },
                "osProfile"=>
                  {
                    "computerName"=>name,
                    "adminUsername"=>username,
                    "linuxConfiguration"=>
                      {
                        "disablePasswordAuthentication"=>disable_password_authentication
                      },
                    "secrets"=>[]
                  },
                "networkProfile"=>
                  {
                    "networkInterfaces"=>
                      [
                        {
                          "id"=>"/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/networkInterfaces/#{network_interface_card_id.split('/')[8]}"
                        }
                      ]
                  },
                "provisioningState"=>"Succeeded"
              }
          }
        end
      end
    end
  end
end
