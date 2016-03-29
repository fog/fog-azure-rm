require 'rest_client'
require 'json'
require ::File.expand_path('../../constants', __FILE__)

module Fog
  module DNS
    module Libraries
      class RecordSet
        def initialize(subscription_id, token)
          @subscription = subscription_id
          @token = token
        end

        def get_existing_records_for_recordset(dns_resource_group, zone_name, record_type, record_set_name)
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription}/resourceGroups/#{dns_resource_group}/providers/Microsoft.Network/dnsZones/#{zone_name}/#{record_type}/#{record_set_name}?api-version=2015-05-04-preview"
          puts "AzureDns::RecordSet - Resource URL is: #{resource_url}"

          existing_records = Array.new
          begin
            dns_response = RestClient.get(
                resource_url,
                accept: 'application/json',
                content_type: 'application/json',
                authorization: @token
            )
          rescue Exception => e
            if e.http_code == 404
              puts 'AzureDns::RecordSet - 404 code, record set does not exist.  returning empty array'
              return existing_records
            else
              puts "Exception trying to get existing #{record_type} records for the record set: #{record_set_name}"
              msg = "AzureDns::RecordSet - Exception is: #{e.message}"
              fail msg
            end
          end

          puts "AzureDns::RecordSet - Getting #{record_type} record response is: #{dns_response}"
          begin
            dns_hash = JSON.parse(dns_response)
            case record_type
              when 'A'
                dns_hash['properties']['ARecords'].each do |record|
                  puts "AzureDns:RecordSet - A record is: #{record}"
                  existing_records.push(record['ipv4Address'])
                end
              when 'CNAME'
                puts "AzureDns:RecordSet - CNAME record is: #{dns_hash['properties']['CNAMERecord']['cname']}"
                existing_records.push(dns_hash['properties']['CNAMERecord']['cname'])
            end
            return existing_records
          rescue Exception => e
            puts "Exception trying to parse response: #{dns_response}"
            msg = "AzureDns::RecordSet - Exception is: #{e.message}"
            fail msg
          end
        end

        def set_records_on_record_set(dns_resource_group, zone_name, record_set_name, records, record_type, ttl)
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription}/resourceGroups/#{dns_resource_group}/providers/Microsoft.Network/dnsZones/#{zone_name}/#{record_type}/#{record_set_name}?api-version=2015-05-04-preview"
          puts "Creating/Updating RecordSet #{record_set_name} of type '#{record_type}' in zone #{zone_name}"

          case record_type
            when 'A'
              a_type_records_array = Array.new
              records.each do |ip|
                a_type_records_array.push({'ipv4Address' => ip})
              end
              body = {
                  :location => 'global',
                  :tags => '',
                  :properties => {
                      :TTL => ttl,
                      :ARecords => a_type_records_array
                  }
              }
            when 'CNAME'
              body = {
                  :location => 'global',
                  :tags => '',
                  :properties => {
                      :TTL => ttl,
                      :CNAMERecord => {
                          'cname' => records.first # because cname only has 1 value and we know the object is an array passed in.
                      }
                  }
              }
          end

          begin
            dns_response = RestClient.put(
                resource_url,
                body.to_json,
                accept: 'application/json',
                content_type: 'application/json',
                authorization: @token
            )
            puts "RecordSet #{record_set_name} Created/Updated Successfully!"
          rescue Exception => e
            puts "Exception setting #{record_type} records for the record set: #{record_set_name}"
            msg = "AzureDns::RecordSet - Exception is: #{e.message}"
            fail msg
          end
        end

        def remove_record_set(record_set_name, dns_resource_group, zone_name, record_type)
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription}/resourceGroups/#{dns_resource_group}/providers/Microsoft.Network/dnsZones/#{zone_name}/#{record_type}/#{record_set_name}?api-version=2015-05-04-preview"
          puts "Deleting RecordSet #{record_set_name} of type '#{record_type}' in zone #{zone_name}"

          begin
            dns_response = RestClient.delete(
                resource_url,
                accept: 'application/json',
                content_type: 'application/json',
                authorization: @token
            )
            puts "RecordSet #{record_set_name} Deleted Successfully!"
          rescue Exception => e
            if e.http_code == 404
              puts 'AzureDns::RecordSet - 404 code, trying to delete something that is not there.'
            else
              puts "Exception trying to remove #{record_type} records for the record set: #{record_set_name}"
              msg = "AzureDns::RecordSet - Exception is: #{e.message}"
              fail msg
            end
          end
        end

        def list_record_sets(dns_resource_group, zone_name)
          resource_url = "#{AZURE_RESOURCE}/subscriptions/#{@subscription}/resourceGroups/#{dns_resource_group}/providers/Microsoft.Network/dnsZones/#{zone_name}/recordsets?api-version=2015-05-04-preview"
          begin
            dns_response = RestClient.get(
                resource_url,
                accept: 'application/json',
                content_type: 'application/json',
                authorization: @token)
            response_hash = JSON.parse(dns_response)
            response_hash['value']
          rescue RestClient::Exception => e
            body = JSON.parse(e.http_body)
            if body.key?('error')
              body = body['error']
              msg = "Exception fetching record_sets: #{body['code']}, #{body['message']}"
            else
              msg = "Exception fetching record_sets: #{body['code']}, #{body['message']}"
            end
            fail msg
          end
        end
      end
    end
  end
end
