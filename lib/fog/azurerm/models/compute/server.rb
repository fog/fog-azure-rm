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

        def self.parse(vm)
          hash = {}
          hash['id'] = vm['id']
          hash['name'] = vm['name']
          hash['location'] = vm['location']
          hash['resource_group'] = vm['id'].split('/')[4]
          hash['vm_size'] = vm['properties']['hardwareProfile']['vmSize']
          hash['os_disk_name'] = vm['properties']['storageProfile']['osDisk']['name']
          hash['os_disk_vhd_uri'] = vm['properties']['storageProfile']['osDisk']['vhd']['uri']
          hash['publisher'] = vm['properties']['storageProfile']['imageReference']['publisher']
          hash['offer'] = vm['properties']['storageProfile']['imageReference']['offer']
          hash['sku'] = vm['properties']['storageProfile']['imageReference']['sku']
          hash['version'] = vm['properties']['storageProfile']['imageReference']['version']
          hash['username'] = vm['properties']['osProfile']['adminUsername']
          hash['data_disks'] = []

          vm['properties']['storageProfile']['dataDisks'].each do |disk|
            data_disk = Fog::Storage::AzureRM::DataDisk.new
            hash['data_disks'] << data_disk.merge_attributes(Fog::Storage::AzureRM::DataDisk.parse(disk))
          end unless vm['properties']['storageProfile']['dataDisks'].nil?

          hash['disable_password_authentication'] =
            if vm['properties']['osProfile']['linuxConfiguration'].nil?
              false
            else
              vm['properties']['osProfile']['linuxConfiguration']['disablePasswordAuthentication']
            end
          if vm['properties']['osProfile']['windowsConfiguration']
            hash['provision_vm_agent'] = vm['properties']['osProfile']['windowsConfiguration']['provisionVMAgent']
            hash['enable_automatic_updates'] = vm['properties']['osProfile']['windowsConfiguration']['enableAutomaticUpdates']
          end
          hash['network_interface_card_id'] = vm['properties']['networkProfile']['networkInterfaces'][0]['id']
          hash['availability_set_id'] = vm['properties']['availabilitySet']['id'] unless vm['properties']['availabilitySet'].nil?
          hash
        end

        def save
          requires :name, :location, :resource_group, :vm_size, :storage_account_name,
                   :username, :password, :network_interface_card_id, :publisher, :offer, :sku, :version
          requires :disable_password_authentication if platform.casecmp('linux') == 0
          ssh_key_path = "/home/#{username}/.ssh/authorized_keys" unless ssh_key_data.nil?
          virtual_machine_params = get_virtual_machine_params(ssh_key_path)
          vm = service.create_virtual_machine(virtual_machine_params)
          merge_attributes(Fog::Compute::AzureRM::Server.parse(vm))
        end

        def get_virtual_machine_params(ssh_key_path)
          virtual_machine_params = {
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
            enable_automatic_updates: enable_automatic_updates
          }
          virtual_machine_params
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
          merge_attributes(Fog::Compute::AzureRM::Server.parse(vm))
        end

        def detach_data_disk(disk_name)
          vm = service.detach_data_disk_from_vm(resource_group, name, disk_name)
          merge_attributes(Fog::Compute::AzureRM::Server.parse(vm))
        end
      end
    end
  end
end
