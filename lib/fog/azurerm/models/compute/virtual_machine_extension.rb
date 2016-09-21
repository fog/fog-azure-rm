module Fog
  module Compute
    class AzureRM
      # This class is giving implementation For Virtual Machine Extension
      class VirtualMachineExtension < Fog::Model
        identity :name
        attribute :id
        attribute :resource_group
        attribute :location
        attribute :type
        attribute :publisher
        attribute :type_handler_version
        attribute :auto_upgrade_minor_version

        def self.parse(vm_extension)
          vm_extension_hash = {}
          vm_extension_hash[:id] = vm_extension.id
          vm_extension_hash[:resource_group] = get_resource_group_from_id(vm_extension.id)
          vm_extension_hash[:name] = vm_extension.name
          vm_extension_hash[:location] = vm_extension.location
          vm_extension_hash[:type] = vm_extension.virtual_machine_extension_type
          vm_extension_hash[:publisher] = vm_extension.publisher
          vm_extension_hash[:type_handler_version] = vm_extension.type_handler_version
          vm_extension_hash[:auto_upgrade_minor_version] = vm_extension.auto_upgrade_minor_version
          vm_extension_hash
        end
      end
    end
  end
end