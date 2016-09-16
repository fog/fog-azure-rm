require 'fog/core/collection'
require 'fog/azurerm/models/storage/file'

module Fog
  module Storage
    class AzureRM
      # This class is giving implementation of listing blobs.
      class Files < Fog::Collection
        model Fog::Storage::AzureRM::File
        attribute :directory

        def all(options = { metadata: true })
          files = []
          service.list_blobs(directory, options).each do |blob|
            hash = File.parse blob
            hash['directory'] = directory
            files << hash
          end
          load files
        end

        def get(directory, name)
          file = File.new(service: service)
          file.directory = directory
          file.key = name
          file
        end
      end
    end
  end
end
