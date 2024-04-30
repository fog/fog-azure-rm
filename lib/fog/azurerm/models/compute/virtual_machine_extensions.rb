module Fog
  module Compute
    class AzureRM
      # This class gives the implementation for get for virtual machine extension
      class VirtualMachineExtensions < Fog::Collection
        model Fog::Compute::AzureRM::VirtualMachineExtension
        attribute :resource_group
        attribute :vm_name

        def all
          requires :resource_group, :vm_name
          vm_extensions = []
          resources = service.get_virtual_machine(resource_group, vm_name, false).resources
          return vm_extensions unless resources
          resources.compact.each do |extension|
            vm_extensions << Fog::Compute::AzureRM::VirtualMachineExtension.parse(extension)
          end
          load(vm_extensions)
        end

        def get(resource_group_name, virtual_machine_name, vm_extension_name)
          vm_extension = service.get_vm_extension(resource_group_name, virtual_machine_name, vm_extension_name)
          vm_extension_fog = Fog::Compute::AzureRM::VirtualMachineExtension.new(service: service)
          vm_extension_fog.merge_attributes(Fog::Compute::AzureRM::VirtualMachineExtension.parse(vm_extension))
        end

        def check_vm_extension_exists(resource_group_name, virtual_machine_name, vm_extension_name)
          service.check_vm_extension_exists(resource_group_name, virtual_machine_name, vm_extension_name)
        end
      end
    end
  end
end
