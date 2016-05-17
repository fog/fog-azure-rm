module Fog
  module DNS
    class AzureRM
      # This class is giving implementation of create/save and
      # delete/destroy for Zone.
      class Zone < Fog::Model
        identity :name
        attribute :id
        attribute :resource_group
        attribute :location
        attribute :type
        attribute :tags
        attribute :etag
        attribute :number_of_record_sets
        attribute :max_number_of_recordsets

        def self.parse(zone)
          hash = {}
          hash['id'] = zone['id']
          hash['name'] = zone['name']
          hash['resource_group'] = zone['resource_group']
          hash['location'] = zone['location']
          hash['type'] = zone['type']
          hash['tags'] = zone['tags']
          hash['etag'] = zone['etag']
          hash['number_of_record_sets'] = zone['numberOfRecordSets']
          hash['max_number_of_recordsets'] = zone['maxNumberOfRecordSets']
        end

        def save
          requires :name
          requires :resource_group
          zone = service.create_zone(resource_group, name)
          merge_attributes(Fog::DNS::AzureRM::Zone.parse(zone))
        end

        def destroy
          service.delete_zone(name, resource_group)
        end
      end
    end
  end
end
