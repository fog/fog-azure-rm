require 'fog/core/collection'
require 'fog/azurerm/models/storage/container'

module Fog
  module Storage
    class AzureRM
      # This class is giving implementation of listing containers.
      class Containers < Fog::Collection
        model Fog::Storage::AzureRM::Container

        def all(options = { :metadata => true })
          containers = []
          service.list_containers(options).each do |container|
            hash = {}
            if container.is_a? Hash
              hash['name'] = container['name']
              hash['last_modified'] = container['properties']['last_modified']
              hash['etag'] = container['properties']['etag']
              hash['lease_duration'] = container['properties']['lease_duration']
              hash['lease_status'] = container['properties']['lease_status']
              hash['lease_state'] = container['properties']['lease_state']
              hash['metadata'] = container['metadata']
            else
              hash['name'] = container.name
              hash['last_modified'] = container.properties[:last_modified]
              hash['etag'] = container.properties[:etag]
              hash['lease_duration'] = container.properties[:lease_duration]
              hash['lease_status'] = container.properties[:lease_status]
              hash['lease_state'] = container.properties[:lease_state]
              hash['metadata'] = container.metadata
            end
            hash['public_access_level'] = 'unknown'
            containers << hash
          end
          load containers
        end

        def get(identity)
          container = all(prefix: identity, metadata: true).find { |item| item.name == identity }
          return if container.nil?

          access_control_list = service.get_container_access_control_list(identity)[0]
          container.public_access_level = if access_control_list.is_a? Hash
                                            access_control_list['public_access_level']
                                          else
                                            access_control_list.public_access_level
                                          end
          container
        end
      end
    end
  end
end
