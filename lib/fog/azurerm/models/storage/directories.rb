module Fog
  module Storage
    class AzureRM
      # This class is giving implementation of listing containers.
      class Directories < Fog::Collection
        model Fog::Storage::AzureRM::Directory

        # List all directories(containers) in the storage account.
        #
        # @return [Fog::Storage::AzureRM::Directories]
        #
        def all
          containers = service.list_containers
          data = []
          containers.each do |container|
            c = parse_storage_object(container)
            c[:acl] = 'unknown'
            data << c
          end
          load(data)
        end

        # Get a directory with files(blobs) under this directory.
        # You can set max_keys to 1 if you do not want to return all files under this directory.
        #
        # @param identity [String] Name of directory
        # @param options  [Hash]
        # @option options [String]  max_keys or
        #                           max_results Sets the maximum number of files to return.
        # @option options [String]  delimiter   Sets to cause that the operation returns a BlobPrefix element in the response body that acts
        #                                       as a placeholder for all files whose names begin with the same substring up to the appearance
        #                                       of the delimiter character. The delimiter may be a single character or a string.
        # @option options [String]  marker      Sets the identifier that specifies the portion of the list to be returned.
        # @option options [String]  prefix      Sets filters the results to return only files whose name begins with the specified prefix.
        #
        # @return [Fog::Storage::AzureRM::Directory] A directory. Return nil if the directory does not exist.
        #
        def get(identity, options = {})
          remap_attributes(options, max_keys: :max_results)

          container = service.get_container_properties(identity)
          data = parse_storage_object(container)
          data[:acl] = 'unknown'

          directory = new(key: identity, is_persisted: true)
          directory.merge_attributes(data)

          data = service.list_blobs(identity, options)

          new_options = options.merge(next_marker: data[:next_marker])
          directory.files.merge_attributes(new_options)

          blobs = []
          data[:blobs].each do |blob|
            blobs << parse_storage_object(blob)
          end
          directory.files.load(blobs)
          directory
        rescue => error
          return nil if error.message == 'NotFound'
          raise error
        end

        def check_container_exists(name)
          service.check_container_exists(name)
        end
      end
    end
  end
end
