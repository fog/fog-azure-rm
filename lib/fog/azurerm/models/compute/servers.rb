require 'fog/core/collection'
require 'fog/azurerm/models/compute/server'
module Fog
  module Compute
    class AzureRM
      # This class is giving implementation of all/list, and get
      # for Server.
      class Servers < Fog::Collection
        model Fog::Compute::AzureRM::Server
        attribute :resource_group
        def all
        end

        def get(resource_group, identity)
        end
      end
    end
  end
end
