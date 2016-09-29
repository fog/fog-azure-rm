module Fog
  module Storage
    class AzureRM
      # This class is giving implementation of create/save and
      # delete/destroy for Blob.
      class File < Fog::Model
        identity  :key, aliases: %w(Name name)
        attribute :accept_ranges
        attribute :cache_control
        attribute :committed_block_count
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
        attribute :directory
        attribute :etag
        attribute :file_path
        attribute :last_modified
        attribute :lease_duration
        attribute :lease_state
        attribute :lease_status
        attribute :metadata
        attribute :sequence_number
        attribute :blob_type

        def save(options = {})
          requires :key
          requires :directory
          merge_attributes(File.parse(service.upload_block_blob_from_file(directory, key, file_path, options)))
        end

        alias create save

        def destroy(options = {})
          requires :key
          requires :directory
          service.delete_blob directory, key, options
        end

        def save_to_file(file_path, options = {})
          requires :key
          requires :directory
          merge_attributes(file_path: file_path)
          merge_attributes(File.parse(service.download_blob_to_file(directory, key, file_path, options)))
        end

        def get_properties(options = {})
          requires :key
          requires :directory
          merge_attributes(File.parse(service.get_blob_properties(directory, key, options)))
        end

        def set_properties(properties = {})
          requires :key
          requires :directory
          service.set_blob_properties(directory, key, properties)
          merge_attributes(properties)
        end

        def get_metadata(options = {})
          requires :key
          requires :directory
          merge_attributes(metadata: service.get_blob_metadata(directory, key, options))
        end

        def set_metadata(metadata, options = {})
          requires :key
          requires :directory
          service.set_blob_metadata(directory, key, metadata, options)
          merge_attributes(metadata: metadata)
        end

        def self.parse(blob)
          if blob.is_a? Hash
            parse_hash blob
          else
            parse_object blob
          end
        end

        def self.parse_hash(blob)
          hash = {}
          hash['key'] = blob['name']
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
          hash
        end

        def self.parse_object(blob)
          hash = {}
          hash['key'] = blob.name
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
          hash
        end
      end
    end
  end
end
