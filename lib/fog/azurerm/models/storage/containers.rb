require 'fog/core/collection'
require 'fog/azurerm/models/storage/container'

module Fog
  module Storage
    class AzureRM
      # This class is giving implementation of listing containers.
      class Containers < Fog::Collection
        model Fog::Storage::AzureRM::Container

        def get_container_metadata(name)
          service.get_container_metadata(name)
        end

        def set_container_metadata(name, metadata)
          service.set_container_metadata(name, metadata)
        end
      end
    end
  end
end