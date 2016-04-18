module Fog
  module Compute
    class AzureRM
      class VirtualMachine < Fog::Model
        identity :name
        attribute :resource_group

        def save
        end

        def destroy
          service.delete_virtual_machine(resource_group, name)
        end
      end
    end
  end
end