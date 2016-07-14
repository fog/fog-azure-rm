require 'fog/core/collection'
require 'fog/azurerm/models/storage/blob'

module Fog
  module Storage
    class AzureRM
      # This class is giving implementation of listing containers.
      class Blobs < Fog::Collection
        model Fog::Storage::AzureRM::Blob
        attribute :container_name

        def get_blob_metadata(container_name, name)
          service.get_blob_metadata(container_name, name)
        end

        def set_blob_metadata(container_name, name, metadata)
          service.set_blob_metadata(container_name, name, metadata)
        end
      end
    end
  end
end
