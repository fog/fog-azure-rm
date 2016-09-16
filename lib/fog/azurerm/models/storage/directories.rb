require 'fog/core/collection'
require 'fog/azurerm/models/storage/directory'

module Fog
  module Storage
    class AzureRM
      # This class is giving implementation of listing containers.
      class Directories < Fog::Collection
        model Fog::Storage::AzureRM::Directory

        def all(options = { metadata: true })
          containers = []
          service.list_containers(options).each do |container|
            hash = Directory.parse container
            hash['public_access_level'] = 'unknown'
            containers << hash
          end
          load containers
        end

        def get(identity)
          container = all(prefix: identity, metadata: true).find { |item| item.key == identity }
          return if container.nil?

          access_control_list = service.get_container_access_control_list(identity)[0]
          container.public_access_level = if access_control_list.is_a? Hash
                                            access_control_list['public_access_level']
                                          else
                                            access_control_list.public_access_level
                                          end
          container
        end

        def get_metadata(name, options = {})
          service.get_container_metadata(name, options)
        end

        def set_metadata(name, metadata, options = {})
          service.set_container_metadata(name, metadata, options)
        end
      end
    end
  end
end
