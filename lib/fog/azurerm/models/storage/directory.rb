module Fog
  module Storage
    class AzureRM
      # This class is giving implementation of create and delete a container.
      class Directory < Fog::Model
        identity  :key, aliases: %w(Name name)
        attribute :etag
        attribute :last_modified
        attribute :lease_duration
        attribute :lease_state
        attribute :lease_status
        attribute :metadata
        attribute :public_access_level

        def create(options = {})
          requires :key
          merge_attributes(Directory.parse(service.create_container(key, options)))
        end

        alias save create

        def get_properties(options = { metadata: true })
          requires :key
          merge_attributes(Directory.parse(service.get_container_properties(key, options)))
        end

        def access_control_list(options = {})
          requires :key
          merge_attributes(Directory.parse(service.get_container_access_control_list(key, options)[0]))
        end

        def destroy(options = {})
          requires :key
          service.delete_container key, options
        end

        def self.parse(container)
          hash = {}
          if container.is_a? Hash
            hash['key'] = container['name']
            hash['metadata'] = container['metadata']
            return hash unless container.key?('properties')

            hash['last_modified'] = container['properties']['last_modified']
            hash['etag'] = container['properties']['etag']
            hash['lease_duration'] = container['properties']['lease_duration']
            hash['lease_status'] = container['properties']['lease_status']
            hash['lease_state'] = container['properties']['lease_state']
          else
            hash['key'] = container.name
            hash['metadata'] = container.metadata
            return hash unless container.respond_to?('properties')

            hash['last_modified'] = container.properties[:last_modified]
            hash['etag'] = container.properties[:etag]
            hash['lease_duration'] = container.properties[:lease_duration]
            hash['lease_status'] = container.properties[:lease_status]
            hash['lease_state'] = container.properties[:lease_state]
          end
          hash
        end
      end
    end
  end
end
