module Fog
  module Compute
    class AzureRM
      class VirtualMachineSizes < Fog::Collection
        attribute :location
        model Fog::Compute::AzureRM::VirtualMachineSize

        def all
          requires :location
          virtual_machine_sizes = service.list_virtual_machine_sizes(location).map do |virtual_machine_size|
            Fog::Compute::AzureRM::VirtualMachineSize.parse(virtual_machine_size)
          end
          load(virtual_machine_sizes)
        end
      end
    end
  end
end
