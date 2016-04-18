require "fog/core/collection"
require "fog/azurerm/models/compute/virtual_machine"

module Fog
  module Compute
    class AzureRM
      class VirtualMachines < Fog::Collection
        attribute :resource_group

        model Fog::Compute::AzureRM::VirtualMachine

        def all
          requires :resource_group
          virtual_machines = []
          service.list_virtual_machines(resource_group).each do |r|
            hash = {}
            r.each do |k, v|
              hash[k] = v
              hash['resource_group'] = resource_group
            end
            virtual_machines << hash
          end
          load(virtual_machines)
        end

        def get(identity)
          all.find { |f| f.name == identity}
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end