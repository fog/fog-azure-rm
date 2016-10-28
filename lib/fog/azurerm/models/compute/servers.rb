module Fog
  module Compute
    class AzureRM
      # This class is giving implementation of all/list, and get
      # for Server.
      class Servers < Fog::Collection
        attribute :resource_group
        model Server

        def all
          requires :resource_group
          virtual_machines = []
          service.list_virtual_machines(resource_group).each do |vm|
            virtual_machines << Server.parse(vm)
          end
          load(virtual_machines)
        end

        def get(resource_group_name, virtual_machine_name)
          virtual_machine = service.get_virtual_machine(resource_group_name, virtual_machine_name)
          virtual_machine_fog = Fog::Compute::AzureRM::Server.new(service: service)
          virtual_machine_fog.merge_attributes(Server.parse(virtual_machine))
        end
      end
    end
  end
end
