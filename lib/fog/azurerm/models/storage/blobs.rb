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

        def get(identity)
          blob = all(prefix: identity, metadata: true).find { |item| item.name == identity }
          return if blob.nil?
          blob.container_name = container_name
          blob
        end

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
