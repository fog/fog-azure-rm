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
          vm_extension_hash = {}
          vm_extension_hash[:id] = vm_extension.id
          vm_extension_hash[:resource_group] = get_resource_group_from_id(vm_extension.id)
          vm_extension_hash[:name] = vm_extension.name
          vm_extension_hash[:location] = vm_extension.location
          vm_extension_hash[:type] = vm_extension.virtual_machine_extension_type
          vm_extension_hash[:publisher] = vm_extension.publisher
          vm_extension_hash[:type_handler_version] = vm_extension.type_handler_version
          vm_extension_hash[:auto_upgrade_minor_version] = vm_extension.auto_upgrade_minor_version
          vm_extension_hash[:settings] = vm_extension.settings
          vm_extension_hash[:protected_settings] = vm_extension.protected_settings
          vm_extension_hash
        end

        def save
          requires :resource_group, :location, :name, :vm_name, :type, :publisher, :type_handler_version,
                   :settings
          vm_extension_params = get_vm_extension_params
          vm_extension = service.add_or_update_vm_extension(vm_extension_params)
          merge_attributes(VirtualMachineExtension.parse(vm_extension))
        end

        def update(input_hash)
          validate_input(input_hash)
          merge_attributes(input_hash) unless input_hash.empty?
          vm_extension_params = get_vm_extension_params
          vm_extension = service.add_or_update_vm_extension(vm_extension_params)
          merge_attributes(VirtualMachineExtension.parse(vm_extension))
        end

        def destroy
          service.delete_vm_extension(resource_group, vm_name, name)
        end

        private

        def validate_input(hash)
          invalid_attr = [:id, :resource_group, :location, :name, :vm_name, :type, :publisher]
          result = invalid_attr & hash.keys
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
            settings: JSON.parse(settings),
            protected_settings: JSON.parse(protected_settings)
          }
        end
      end
    end
  end
end