module Fog
  module Storage
    class AzureRM
      # This class is giving implementation of create/save and
      # delete/destroy for Recovery Vault.
      class RecoveryVault < Fog::Model
        attribute :id
        identity :name
        attribute :resource_group
        attribute :location
        attribute :type
        attribute :sku_name

        def self.parse(recovery_vault)
          {
            id: recovery_vault['id'],
            name: recovery_vault['name'],
            resource_group: get_resource_group_from_id(recovery_vault['id']),
            location: recovery_vault['location'],
            type: recovery_vault['type'],
            sku_name: recovery_vault['sku']['name']
          }
        end

        def save
          requires :name, :location, :resource_group
          recovery_vault = service.create_or_update_recovery_vault(resource_group, location, name)
          merge_attributes(RecoveryVault.parse(recovery_vault))
        end

        def enable_backup_protection(vm_name, vm_resource_group)
          requires :name, :resource_group
          service.enable_backup_protection(name, resource_group, vm_name, vm_resource_group)
        end

        def start_backup(vm_name, vm_resource_group)
          service.start_backup(resource_group, name, vm_name, vm_resource_group)
        end

        def disable_backup_protection(vm_name, vm_resource_group)
          service.disable_backup_protection(name, resource_group, vm_name, vm_resource_group)
        end

        def destroy
          service.delete_recovery_vault(resource_group, name)
        end
      end
    end
  end
end