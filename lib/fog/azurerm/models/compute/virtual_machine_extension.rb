module Fog
  module Compute
    class AzureRM
      # This class is giving implementation For Virtual Machine Extension
      class VirtualMachineExtension < Fog::Model
        identity :name
        attribute :id
        attribute :resource_group
        attribute :location
        attribute :vm_name
        attribute :type
        attribute :publisher
        attribute :type_handler_version
        attribute :auto_upgrade_minor_version
        attribute :settings
        attribute :protected_settings

        def self.parse(vm_extension)
          virtual_machine_extension = {}
          virtual_machine_extension[:id] = vm_extension.id
          virtual_machine_extension[:resource_group] = get_resource_group_from_id(vm_extension.id)
          virtual_machine_extension[:name] = vm_extension.name
          virtual_machine_extension[:location] = vm_extension.location
          virtual_machine_extension[:vm_name] = get_virtual_machine_from_id(vm_extension.id)
          virtual_machine_extension[:type] = vm_extension.virtual_machine_extension_type
          virtual_machine_extension[:publisher] = vm_extension.publisher
          virtual_machine_extension[:type_handler_version] = vm_extension.type_handler_version
          virtual_machine_extension[:auto_upgrade_minor_version] = vm_extension.auto_upgrade_minor_version
          virtual_machine_extension[:settings] = vm_extension.settings
          virtual_machine_extension[:protected_settings] = vm_extension.protected_settings
          virtual_machine_extension
        end

        def save
          requires :resource_group, :location, :name, :vm_name, :type, :publisher, :type_handler_version, :settings
          vm_extension_params = get_vm_extension_params
          vm_extension = service.add_or_update_vm_extension(vm_extension_params)
          merge_attributes(VirtualMachineExtension.parse(vm_extension))
        end

        def update(vm_extension_input)
          validate_input(vm_extension_input)
          merge_attributes(vm_extension_input) unless vm_extension_input.empty?
          vm_extension_params = get_vm_extension_params
          vm_extension = service.add_or_update_vm_extension(vm_extension_params)
          merge_attributes(VirtualMachineExtension.parse(vm_extension))
        end

        def destroy
          service.delete_vm_extension(resource_group, vm_name, name)
        end

        private

        def validate_input(vm_extension_input)
          invalid_attr = [:id, :resource_group, :location, :name, :vm_name, :type, :publisher]
          result = invalid_attr & vm_extension_input.keys
          raise 'Cannot modify the given attribute(s)' unless result.empty?
        end

        def get_vm_extension_params
          {
            resource_group: resource_group,
            location: location,
            name: name,
            vm_name: vm_name,
            type: type,
            publisher: publisher,
            type_handler_version: type_handler_version,
            auto_upgrade_minor_version: auto_upgrade_minor_version,
            settings: settings,
            protected_settings: protected_settings
          }
        end
      end
    end
  end
end
