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
        attribute :os_disk_caching
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
        attribute :network_interface_card_ids
        attribute :availability_set_id
        attribute :custom_data
        attribute :vhd_path
        attribute :managed_disk_storage_type
        attribute :os_disk_size
        attribute :tags

        def self.parse(vm)
          hash = {}
          hash['id'] = vm.id
          hash['name'] = vm.name
          hash['location'] = vm.location
          hash['resource_group'] = get_resource_group_from_id(vm.id)
          hash['vm_size'] = vm.hardware_profile.vm_size unless vm.hardware_profile.vm_size.nil?
          unless vm.storage_profile.nil?
            hash['os_disk_name'] = vm.storage_profile.os_disk.name
            hash['os_disk_size'] = vm.storage_profile.os_disk.disk_size_gb
            if vm.storage_profile.os_disk.vhd.nil?
              hash['managed_disk_storage_type'] = vm.storage_profile.os_disk.managed_disk.storage_account_type
            else
              hash['os_disk_vhd_uri'] = vm.storage_profile.os_disk.vhd.uri
              hash['storage_account_name'] = hash['os_disk_vhd_uri'].split('/')[2].split('.')[0]
            end

            hash['os_disk_caching'] = vm.storage_profile.os_disk.caching
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

          unless vm.storage_profile.data_disks.nil?
            vm.storage_profile.data_disks.each do |disk|
              data_disk = Fog::Compute::AzureRM::DataDisk.new
              hash['data_disks'] << data_disk.merge_attributes(Fog::Compute::AzureRM::DataDisk.parse(disk))
            end
          end

          hash['disable_password_authentication'] = false
          hash['disable_password_authentication'] = vm.os_profile.linux_configuration.disable_password_authentication unless vm.os_profile.linux_configuration.nil?
          if vm.os_profile.windows_configuration
            hash['provision_vm_agent'] = vm.os_profile.windows_configuration.provision_vmagent
            hash['enable_automatic_updates'] = vm.os_profile.windows_configuration.enable_automatic_updates
          end
          hash['network_interface_card_ids'] = vm.network_profile.network_interfaces.map(&:id)
          hash['availability_set_id'] = vm.availability_set.id unless vm.availability_set.nil?
          hash['tags'] = vm.tags

          hash
        end

        def save(async = false)
          requires :name, :location, :resource_group, :vm_size, :storage_account_name,
                   :username, :network_interface_card_ids
          requires :publisher, :offer, :sku, :version if vhd_path.nil? && managed_disk_storage_type.nil?

          if platform_is_linux?(platform)
            requires :disable_password_authentication
          else
            requires :password
          end

          ssh_key_path = "/home/#{username}/.ssh/authorized_keys" unless ssh_key_data.nil?

          if async
            service.create_virtual_machine(virtual_machine_params(ssh_key_path), true)
          else
            vm = service.create_virtual_machine(virtual_machine_params(ssh_key_path))
            merge_attributes(Fog::Compute::AzureRM::Server.parse(vm))
          end
        end

        def destroy(async = false)
          response = service.delete_virtual_machine(resource_group, name, async)
          async ? create_fog_async_response(response) : response
        end

        def generalize(async = false)
          response = service.generalize_virtual_machine(resource_group, name, async)
          async ? create_fog_async_response(response) : response
        end

        def power_off(async = false)
          response = service.power_off_virtual_machine(resource_group, name, async)
          async ? create_fog_async_response(response) : response
        end

        def start(async = false)
          response = service.start_virtual_machine(resource_group, name, async)
          async ? create_fog_async_response(response) : response
        end

        def restart(async = false)
          response = service.restart_virtual_machine(resource_group, name, async)
          async ? create_fog_async_response(response) : response
        end

        def deallocate(async = false)
          response = service.deallocate_virtual_machine(resource_group, name, async)
          async ? create_fog_async_response(response) : response
        end

        def redeploy(async = false)
          response = service.redeploy_virtual_machine(resource_group, name, async)
          async ? create_fog_async_response(response) : response
        end

        def list_available_sizes(async = false)
          response = service.list_available_sizes_for_virtual_machine(resource_group, name, async)
          async ? create_fog_async_response(response) : response
        end

        def vm_status(async = false)
          service.check_vm_status(resource_group, name, async)
        end

        def attach_data_disk(disk_name, disk_size, storage_account_name, async = false)
          response = service.attach_data_disk_to_vm(data_disk_params(disk_name, disk_size, storage_account_name), async)
          async ? create_fog_async_response(response) : merge_attributes(Fog::Compute::AzureRM::Server.parse(response))
        end

        def detach_data_disk(disk_name, async = false)
          response = service.detach_data_disk_from_vm(resource_group, name, disk_name, async)
          async ? create_fog_async_response(response) : merge_attributes(Fog::Compute::AzureRM::Server.parse(response))
        end

        def attach_managed_disk(disk_name, disk_resource_group, async = false)
          response = service.attach_data_disk_to_vm(data_disk_params(disk_name, nil, nil, disk_resource_group), async)
          async ? create_fog_async_response(response) : merge_attributes(Fog::Compute::AzureRM::Server.parse(response))
        end

        def detach_managed_disk(disk_name, async = false)
          response = service.detach_data_disk_from_vm(resource_group, name, disk_name, async)
          async ? create_fog_async_response(response) : merge_attributes(Fog::Compute::AzureRM::Server.parse(response))
        end

        private

        def platform_is_linux?(platform)
          platform.strip.casecmp(PLATFORM_LINUX).zero?
        end

        def create_fog_async_response(response)
          server = Fog::Compute::AzureRM::Server.new(service: service)
          Fog::AzureRM::AsyncResponse.new(server, response)
        end

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
            network_interface_card_ids: network_interface_card_ids,
            availability_set_id: availability_set_id,
            publisher: publisher,
            offer: offer,
            sku: sku,
            version: version,
            platform: platform,
            provision_vm_agent: provision_vm_agent,
            enable_automatic_updates: enable_automatic_updates,
            custom_data: custom_data,
            vhd_path: vhd_path,
            os_disk_caching: os_disk_caching,
            managed_disk_storage_type: managed_disk_storage_type,
            os_disk_size: os_disk_size,
            tags: tags
          }
        end

        def data_disk_params(disk_name, disk_size = nil, storage_account = nil, disk_resource_group = nil)
          {
            vm_name: name,
            vm_resource_group: resource_group,
            disk_name: disk_name,
            disk_size_gb: disk_size,
            storage_account_name: storage_account,
            disk_resource_group: disk_resource_group
          }
        end
      end
    end
  end
end
