require 'fog/core/collection'
require 'fog/azurerm/models/storage/blob'

module Fog
  module Storage
    class AzureRM
      # This class is giving implementation of listing blobs.
      class Blobs < Fog::Collection
        model Fog::Storage::AzureRM::Blob
        attribute :container_name

        def all(options = { metadata: true })
          blobs = []
          service.list_blobs(container_name, options).each do |blob|
            hash = Blob.parse blob
            hash['container_name'] = container_name
            blobs << hash
          end
          load blobs
        end

        def get(container_name, blob_name)
          blob = Blob.new(service: service)
          blob.container_name = container_name
          blob.name = blob_name
          blob
        end
      end
    end
  end
end
