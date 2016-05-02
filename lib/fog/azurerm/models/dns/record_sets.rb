require "fog/core/collection"
require "fog/azurerm/models/dns/record_set"

module Fog
  module DNS
    class AzureRM
      class RecordSets < Fog::Collection

        attribute :resource_group
        attribute :zone_name
        attribute :type

        model Fog::DNS::AzureRM::RecordSet

        def all
          requires :resource_group
          requires :zone_name
          record_sets = []
          exclude = false
          service.list_record_sets(resource_group, zone_name).each do |r|
            hash = {}
            r.each do |k, v|
              if (k == 'name' && v == '@')
                exclude = true
              end
              hash[k] = v
              hash['zone_name'] = zone_name
              hash['resource_group'] = resource_group
            end
            record_sets << hash if !exclude
            exclude = false
          end
          load(record_sets)
        end

        def get(identity, type)
          all.find { |f| f.name == identity && f.type == "Microsoft.Network/dnszones/#{type}"}
        end
      end
    end
  end
end