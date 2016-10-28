module Fog
  module DNS
    class AzureRM
      # This class is giving implementation of
      # all/get for RecordSets.
      class RecordSets < Fog::Collection
        attribute :resource_group
        attribute :zone_name
        attribute :type

        model RecordSet

        def all
          requires :resource_group, :zone_name
          record_sets = []
          service.list_record_sets(resource_group, zone_name).each do |r|
            record_sets << RecordSet.parse(r)
          end
          load(record_sets)
        end

        def get(resource_group, name, zone_name, record_type)
          record_set = service.get_record_set(resource_group, name, zone_name, record_type)
          record_set_fog = RecordSet.new(service: service)
          record_set_fog.merge_attributes(RecordSet.parse(record_set))
        end
      end
    end
  end
end
