module Fog
  module DNS
    class AzureRM
      # This class is giving implementation of create/save and
      # delete/destroy for RecordSet.
      class RecordSet < Fog::Model
        identity :name
        attribute :resource_group
        attribute :zone_name
        attribute :records
        attribute :type
        attribute :ttl

        def save
          requires :name
          requires :resource_group
          requires :zone_name
          requires :records
          requires :type
          requires :ttl
          service.create_record_set(resource_group, zone_name, name, records, type, ttl)
        end

        def destroy
          service.delete_record_set(name, resource_group, zone_name, type.split('/').last)
        end

        def get_records(record_set_name, dns_resource_group, zone_name, record_type)
          service.get_records_from_record_set(record_set_name, dns_resource_group, zone_name, record_type)
        end
      end
    end
  end
end
