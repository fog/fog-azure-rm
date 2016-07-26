module Fog
  module DNS
    class AzureRM
      # This class is giving implementation of create/save and
      # delete/destroy for RecordSet.
      class RecordSet < Fog::Model
        attribute :id
        identity :name
        attribute :resource_group
        attribute :location
        attribute :zone_name
        attribute :records
        attribute :type
        attribute :ttl
        attribute :fqdn
        attribute :cname_record
        attribute :a_record

        def self.parse(recordset)
          hash = {}
          hash['id'] = recordset['id']
          hash['name'] = recordset['name']
          hash['resource_group'] = recordset['id'].split('/')[4]
          hash['location'] = recordset['location']
          hash['zone_name'] = recordset['id'].split('/')[8]
          hash['type'] = recordset['type']
          type = recordset['type'].split('/')[2]
          hash['records'] = []
          if type == 'A'
            record_entries = recordset['properties']['ARecords']
            record_entries.each do |record|
              hash['records'] << record['ipv4Address']
            end
          end
          if type == 'CNAME'
            record_entries = recordset['properties']['CNAMERecord']['cname']
            hash['records'] << record_entries
          end
          hash['a_record'] = recordset['properties']['ARecords'] if type == 'A'
          hash['cname_record'] = recordset['properties']['CNAMERecord'] if type == 'CNAME'
          hash['ttl'] = recordset['properties']['TTL']
          hash['fqdn'] = recordset['properties']['fqdn']
          hash
        end

        def save
          requires :name
          requires :resource_group
          requires :zone_name
          requires :records
          requires :type
          requires :ttl
          record_set = service.create_record_set(resource_group, name, zone_name, records, type, ttl)
          merge_attributes(Fog::DNS::AzureRM::RecordSet.parse(record_set))
        end

        def destroy
          service.delete_record_set(resource_group, name, zone_name, type.split('/').last)
        end

        def get_records(resource_group, name, zone_name, record_type)
          service.get_records_from_record_set(resource_group, name, zone_name, record_type)
        end

        def update_ttl(options)
          if !options[:name].nil? || !options[:resource_group].nil? || !options[:zone_name].nil? || !options[:id].nil? || !options[:type].nil? || !options[:records].nil?
            raise 'You cannot modify :name, :resource group, :records, :zone_name, :type and :id'
          end
          merge_attributes(options)
          record_set = service.create_record_set(resource_group, name, zone_name, records, type.split('/').last, ttl)
          merge_attributes(Fog::DNS::AzureRM::RecordSet.parse(record_set))
        end

        def add_A_type_record(record)
          records << record
          record_set = service.create_record_set(resource_group, name, zone_name, records, type.split('/').last, ttl)
          merge_attributes(Fog::DNS::AzureRM::RecordSet.parse(record_set))
        end

        def remove_A_type_record(record)
          records.delete(record)
          record_set = service.create_record_set(resource_group, name, zone_name, records, type.split('/').last, ttl)
          merge_attributes(Fog::DNS::AzureRM::RecordSet.parse(record_set))
        end
      end
    end
  end
end
