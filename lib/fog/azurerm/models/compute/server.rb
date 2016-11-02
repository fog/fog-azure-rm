require 'fog/azurerm/models/storage/data_disk'
module Fog
  module Compute
    class AzureRM
      # This class is giving implementation of create/save and
      # delete/destroy for Virtual Machine.
      class Server < Fog::Model
        attribute :id
        identity  :name
        attribute :location
        attribute :resource_group
        attribute :vm_size
        attribute :storage_account_name
        attribute :os_disk_name
        attribute :os_disk_vhd_uri
        attribute :publisher
        attribute :offer
        attribute :sku
        attribute :version
        attribute :username
        attribute :password
        attribute :data_disks
        attribute :disable_password_authentication
        attribute :ssh_key_path
        attribute :ssh_key_data
        attribute :platform
        attribute :provision_vm_agent
        attribute :enable_automatic_updates
        attribute :network_interface_card_id
        attribute :availability_set_id
        attribute :custom_data
        attribute :vhd_path

        def self.parse(vm)
          hash = {}
          hash['id'] = vm.id
          hash['name'] = vm.name
          hash['location'] = vm.location
          hash['resource_group'] = get_resource_group_from_id(vm.id)
          hash['vm_size'] = vm.hardware_profile.vm_size unless vm.hardware_profile.vm_size.nil?
          unless vm.storage_profile.nil?
            hash['os_disk_name'] = vm.storage_profile.os_disk.name
            hash['os_disk_vhd_uri'] = vm.storage_profile.os_disk.vhd.uri
            unless vm.storage_profile.image_reference.nil?
              hash['publisher'] = vm.storage_profile.image_reference.publisher
              hash['offer'] = vm.storage_profile.image_reference.offer
              hash['sku'] = vm.storage_profile.image_reference.sku
              hash['version'] = vm.storage_profile.image_reference.version
            end
          end
          hash['username'] = vm.os_profile.admin_username
          hash['custom_data'] = vm.os_profile.custom_data
          hash['data_disks'] = []

          vm.storage_profile.data_disks.each do |disk|
            data_disk = DataDisk.new
            hash['data_disks'] << data_disk.merge_attributes(DataDisk.parse(disk))
          end unless vm.storage_profile.data_disks.nil?

          hash['disable_password_authentication'] = false
          hash['disable_password_authentication'] = vm.os_profile.linux_configuration.disable_password_authentication unless vm.os_profile.linux_configuration.nil?
          if vm.os_profile.windows_configuration
            hash['provision_vm_agent'] = vm.os_profile.windows_configuration.provision_vmagent
            hash['enable_automatic_updates'] = vm.os_profile.windows_configuration.enable_automatic_updates
          end
          hash['network_interface_card_id'] = vm.network_profile.network_interfaces[0].id
          hash['availability_set_id'] = vm.availability_set.id unless vm.availability_set.nil?

          hash
        end

        def save
          requires :name, :location, :resource_group, :vm_size, :storage_account_name,
                   :username, :password, :network_interface_card_id
          requires :disable_password_authentication if platform.casecmp('linux').zero?
          requires :publisher, :offer, :sku, :version if vhd_path.nil?
          ssh_key_path = "/home/#{username}/.ssh/authorized_keys" unless ssh_key_data.nil?
          vm = service.create_virtual_machine(virtual_machine_params(ssh_key_path))
          merge_attributes(Server.parse(vm))
        end

        def destroy
          service.delete_virtual_machine(resource_group, name)
        end

        def generalize
          service.generalize_virtual_machine(resource_group, name)
        end

        def power_off
          service.power_off_virtual_machine(resource_group, name)
        end

        def start
          service.start_virtual_machine(resource_group, name)
        end

        def restart
          service.restart_virtual_machine(resource_group, name)
        end

        def deallocate
          service.deallocate_virtual_machine(resource_group, name)
        end

        def redeploy
          service.redeploy_virtual_machine(resource_group, name)
        end

        def list_available_sizes
          service.list_available_sizes_for_virtual_machine(resource_group, name)
        end

        def vm_status
          service.check_vm_status(resource_group, name)
        end

        def attach_data_disk(disk_name, disk_size, storage_account_name)
          vm = service.attach_data_disk_to_vm(resource_group, name, disk_name, disk_size, storage_account_name)
          merge_attributes(Server.parse(vm))
        end

        def detach_data_disk(disk_name)
          vm = service.detach_data_disk_from_vm(resource_group, name, disk_name)
          merge_attributes(Server.parse(vm))
        end

        private

        def virtual_machine_params(ssh_key_path)
          {
            resource_group: resource_group,
            name: name,
            location: location,
            vm_size: vm_size,
            storage_account_name: storage_account_name,
            username: username,
            password: password,
            disable_password_authentication: disable_password_authentication,
            ssh_key_path: ssh_key_path,
            ssh_key_data: ssh_key_data,
            network_interface_card_id: network_interface_card_id,
            availability_set_id: availability_set_id,
            publisher: publisher,
            offer: offer,
            sku: sku,
            version: version,
            platform: platform,
            provision_vm_agent: provision_vm_agent,
            enable_automatic_updates: enable_automatic_updates,
            custom_data: custom_data,
            vhd_path: vhd_path
          }
        end
      end
    end
  end
end
