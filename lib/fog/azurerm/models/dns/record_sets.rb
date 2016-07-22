require 'fog/core/collection'
require 'fog/azurerm/models/dns/record_set'

module Fog
  module DNS
    class AzureRM
      # This class is giving implementation of
      # all/get for RecordSets.
      class RecordSets < Fog::Collection
        attribute :resource_group
        attribute :zone_name
        attribute :type

        model Fog::DNS::AzureRM::RecordSet

        def all
          requires :resource_group
          requires :zone_name
          record_sets = []
          service.list_record_sets(resource_group, zone_name).each do |r|
            record_sets << Fog::DNS::AzureRM::RecordSet.parse(r)
          end
          load(record_sets)
        end

        def get(resource_group, name, zone_name, record_type)
          record_set = service.get_record_set(resource_group, name, zone_name, record_type)
          record_set_obj = Fog::DNS::AzureRM::RecordSet.new
          record_set_obj.instance_variable_set(:@service, service)
          record_set_obj.merge_attributes(Fog::DNS::AzureRM::RecordSet.parse(record_set))
        end
      end
    end
  end
end
