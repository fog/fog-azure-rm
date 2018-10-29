module Fog
  module Compute
    class AzureRM
      class VirtualMachineSizes < Fog::Collection
        attribute :location
        model Fog::Compute::AzureRM::VirtualMachineSize
      end
    end
  end
end
