module Fog
  module Storage
    class AzureRM
      # This class is giving implementation of create/save and
      # delete/destroy for Blob.
      class Blob < Fog::Model
        identity  :name
        attribute :accept_ranges
        attribute :cache_control
        attribute :committed_block_count
        attribute :container_name
        attribute :content_length
        attribute :content_type
        attribute :content_md5
        attribute :content_encoding
        attribute :content_language
        attribute :content_disposition
        attribute :copy_completion_time
        attribute :copy_status
        attribute :copy_status_description
        attribute :copy_id
        attribute :copy_progress
        attribute :copy_source
        attribute :etag
        attribute :lease_duration
        attribute :lease_state
        attribute :lease_status
        attribute :last_modified
        attribute :metadata
        attribute :sequence_number
        attribute :blob_type

        def save(options = {})
          requires :name
          requires :container_name
          if options.key?(:file_path)
            merge_attributes(Blob.parse(service.upload_block_blob_from_file(container_name, name, options[:file_path], options)))
          else
            merge_attributes(Blob.parse(service.upload_block_blob_from_file(container_name, name, nil, options)))
          end
        end

        alias create save

        def get_to_file(file_path, options = {})
          requires :name
          requires :container_name
          merge_attributes(Blob.parse(service.download_blob_to_file(container_name, name, file_path, options)))
        end

        def get_properties(options = {})
          requires :name
          requires :container_name
          merge_attributes(Blob.parse(service.get_blob_properties(container_name, name, options)))
        end

        def set_properties(options = {})
          requires :name
          requires :container_name
          service.set_blob_properties(container_name, name, options)
        end

        def self.parse(blob)
          hash = {}
          if blob.is_a? Hash
            hash['name'] = blob['name']
            hash['metadata'] = blob['metadata']
            return hash unless blob.key?('properties')

            hash['last_modified'] = blob['properties']['last_modified']
            hash['etag'] = blob['properties']['etag']
            hash['lease_duration'] = blob['properties']['lease_duration']
            hash['lease_status'] = blob['properties']['lease_status']
            hash['lease_state'] = blob['properties']['lease_state']
            hash['content_length'] = blob['properties']['content_length']
            hash['content_type'] = blob['properties']['content_type']
            hash['content_encoding'] = blob['properties']['content_encoding']
            hash['content_language'] = blob['properties']['content_language']
            hash['content_disposition'] = blob['properties']['content_disposition']
            hash['content_md5'] = blob['properties']['content_md5']
            hash['cache_control'] = blob['properties']['cache_control']
            hash['sequence_number'] = blob['properties']['sequence_number']
            hash['blob_type'] = blob['properties']['blob_type']
            hash['copy_id'] = blob['properties']['copy_id']
            hash['copy_status'] = blob['properties']['copy_status']
            hash['copy_source'] = blob['properties']['copy_source']
            hash['copy_progress'] = blob['properties']['copy_progress']
            hash['copy_completion_time'] = blob['properties']['copy_completion_time']
            hash['copy_status_description'] = blob['properties']['copy_status_description']
            hash['accept_ranges'] = blob['properties']['accept_ranges']
          else
            hash['name'] = blob.name
            hash['metadata'] = blob.metadata
            return hash unless blob.respond_to?('properties')

            hash['last_modified'] = blob.properties[:last_modified]
            hash['etag'] = blob.properties[:etag]
            hash['lease_duration'] = blob.properties[:lease_duration]
            hash['lease_status'] = blob.properties[:lease_status]
            hash['lease_state'] = blob.properties[:lease_state]
            hash['content_length'] = blob.properties[:content_length]
            hash['content_type'] = blob.properties[:content_type]
            hash['content_encoding'] = blob.properties[:content_encoding]
            hash['content_language'] = blob.properties[:content_language]
            hash['content_disposition'] = blob.properties[:content_disposition]
            hash['content_md5'] = blob.properties[:content_md5]
            hash['cache_control'] = blob.properties[:cache_control]
            hash['sequence_number'] = blob.properties[:sequence_number]
            hash['blob_type'] = blob.properties[:blob_type]
            hash['copy_id'] = blob.properties[:copy_id]
            hash['copy_status'] = blob.properties[:copy_status]
            hash['copy_source'] = blob.properties[:copy_source]
            hash['copy_progress'] = blob.properties[:copy_progress]
            hash['copy_completion_time'] = blob.properties[:copy_completion_time]
            hash['copy_status_description'] = blob.properties[:copy_status_description]
            hash['accept_ranges'] = blob.properties[:accept_ranges]
          end
          hash
        end
      end
    end
  end
end
