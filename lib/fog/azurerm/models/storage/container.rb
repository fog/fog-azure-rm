module Fog
  module Storage
    class AzureRM
      # This class is giving implementation of create and delete a container.
      class Container < Fog::Model
        identity  :name
        attribute :etag
        attribute :last_modified
        attribute :lease_duration
        attribute :lease_state
        attribute :lease_status
        attribute :metadata
        attribute :public_access_level

        def create(options = {})
          requires :name
          merge_attributes(Container.parse(service.create_container(name, options)))
        end

        alias save create

        def get_properties(options = { metadata: true })
          requires :name
          merge_attributes(Container.parse(service.get_container_properties(name, options)))
        end

        def get_access_control_list(options = {})
          requires :name
          merge_attributes(service.get_container_access_control_list(name, options)[0])
        end

        def delete(options = {})
          requires :name
          service.delete_container name, options
        end

        def self.parse(container)
          return container unless container.key?('properties')
          container['etag'] = container['properties']['etag']
          container['last_modified'] = container['properties']['last_modified']
          container['lease_duration'] = container['properties']['lease_duration']
          container['lease_state'] = container['properties']['lease_state']
          container['lease_status'] = container['properties']['lease_status']
          container.delete 'properties'
          container
        end
      end
    end
  end
end
