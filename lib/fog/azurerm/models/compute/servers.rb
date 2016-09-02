require 'fog/core/collection'
require 'fog/azurerm/models/compute/server'

module Fog
  module Compute
    class AzureRM
      # This class is giving implementation of all/list, and get
      # for Server.
      class Servers < Fog::Collection
        attribute :resource_group
        model Fog::Compute::AzureRM::Server

        def all
          requires :resource_group
          virtual_machines = []
          service.list_virtual_machines(resource_group).each do |vm|
            virtual_machines << Fog::Compute::AzureRM::Server.parse(vm)
          end
          load(virtual_machines)
        end

        def get(resource_group_name, virtual_machine_name)
          storage_account = service.get_virtual_machine(resource_group_name, virtual_machine_name)
          storage_account_obj = Fog::Compute::AzureRM::Server.new(service: service)
          storage_account_obj.merge_attributes(Fog::Compute::AzureRM::Server.parse(storage_account))
        end
      end
    end
  end
end
