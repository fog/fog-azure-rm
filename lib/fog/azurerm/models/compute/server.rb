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
        attribute :vhd_uri
        attribute :publisher
        attribute :offer
        attribute :sku
        attribute :version
        attribute :username
        attribute :password
        attribute :disable_password_authentication
        attribute :ssh_key_path
        attribute :ssh_key_data
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
          hash['vhd_uri'] = vm['properties']['storageProfile']['osDisk']['vhd']['uri']
          hash['publisher'] = vm['properties']['storageProfile']['imageReference']['publisher']
          hash['offer'] = vm['properties']['storageProfile']['imageReference']['offer']
          hash['sku'] = vm['properties']['storageProfile']['imageReference']['sku']
          hash['version'] = vm['properties']['storageProfile']['imageReference']['version']
          hash['username'] = vm['properties']['osProfile']['adminUsername']
          hash['disable_password_authentication'] = vm['properties']['osProfile']['linuxConfiguration']['disablePasswordAuthentication']
          hash['network_interface_card_id'] = vm['properties']['networkProfile']['networkInterfaces'][0]['id']
          hash['availability_set_id'] = vm['properties']['availabilitySet']['id'] unless vm['properties']['availabilitySet'].nil?
          hash
        end

        def save
          requires :name, :location, :resource_group, :vm_size, :storage_account_name,
                   :username, :password, :disable_password_authentication,
                   :network_interface_card_id, :publisher, :offer, :sku, :version

          ssh_key_path = "/home/#{username}/.ssh/authorized_keys" unless ssh_key_data.nil?
          vm = service.create_virtual_machine(name, location, resource_group, vm_size, storage_account_name,
                                         username, password, disable_password_authentication,
                                         ssh_key_path, ssh_key_data, network_interface_card_id,
                                         availability_set_id, publisher, offer, sku, version)
          merge_attributes(Fog::Compute::AzureRM::Server.parse(vm))
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
      end
    end
  end
end
