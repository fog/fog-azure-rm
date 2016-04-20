require "fog/core/collection"
require "fog/azurerm/models/compute/server"

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

        def get_from_remote(resource_group, name)
          service.get_virtual_machine(resource_group, name)
        end
      end
    end
  end
end
