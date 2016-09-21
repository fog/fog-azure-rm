require 'fog/core/collection'
require 'fog/azurerm/models/compute/virtual_machine_extension'

module Fog
  module Compute
    class AzureRM
      # This class gives the implementation for get for virtual machine extension
      class VirtualMachineExtensions < Fog::Collection
        model Fog::Compute::AzureRM::VirtualMachineExtension

        def all

        end

        def get(resource_group_name, virtual_machine_name, vm_extension_name)
          vm_extension = service.get_vm_extension(resource_group_name, virtual_machine_name, vm_extension_name)
          vm_extension_obj = Fog::Compute::AzureRM::VirtualMachineExtension.new(service: service)
          vm_extension_obj.merge_attributes(Fog::Compute::AzureRM::VirtualMachineExtension.parse(vm_extension))
        end
      end
    end
  end
end