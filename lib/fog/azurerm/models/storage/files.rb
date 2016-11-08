module Fog
  module Storage
    class AzureRM
      # This class is giving implementation of listing blobs.
      class Files < Fog::Collection
        attribute :directory
        attribute :delimiter,       aliases: 'Delimiter'
        attribute :marker,          aliases: 'Marker'
        attribute :max_results,     aliases: %w(max-results MaxResults max_keys MaxKeys max-keys)
        attribute :next_marker,     aliases: %w(NextMarker next-marker)
        attribute :prefix,          aliases: 'Prefix'

        model Fog::Storage::AzureRM::File

        # List all files(blobs) under the directory.
        #
        #     required attributes: directory
        #
        # @param options [Hash]
        # @option options [String]  max_keys or
        #                           max_results Sets the maximum number of files to return.
        # @option options [String]  delimiter   Sets to cause that the operation returns a BlobPrefix element in the response body that acts
        #                                       as a placeholder for all files whose names begin with the same substring up to the appearance
        #                                       of the delimiter character. The delimiter may be a single character or a string.
        # @option options [String]  marker      Sets the identifier that specifies the portion of the list to be returned.
        # @option options [String]  prefix      Sets filters the results to return only files whose name begins with the specified prefix.
        #
        # @return [Fog::Storage::AzureRM::Files] Return nil if the directory does not exist.
        #
        def all(options = {})
          requires :directory

          options = {
            max_results: max_results,
            delimiter: delimiter,
            marker: marker,
            prefix: prefix
          }.merge!(options)
          options = options.reject { |_key, value| value.nil? || value.to_s.empty? }
          merge_attributes(options)
          parent = directory.collection.get(
            directory.key,
            options
          )
          return nil unless parent

          merge_attributes(parent.files.attributes)
          load(parent.files.map(&:attributes))
        end

        # Enumerate every file under the directory if block_given?
        #
        # @return [Fog::Storage::AzureRM::Files]
        #
        alias each_file_this_page each
        def each
          if block_given?
            subset = dup.all

            subset.each_file_this_page { |f| yield f }
            while subset.next_marker
              subset = subset.all(marker: subset.next_marker)
              subset.each_file_this_page { |f| yield f }
            end
          end

          self
        end

        # Get the file(blob) with full content as :body with the given name.
        #
        #     required attributes: directory
        #
        # @param key     [String] Name of file
        # @param options [Hash]
        # @option options [String]  block_size Sets buffer size when block_given? is true. Default is 32 MB
        #
        # @return [Fog::Storage::AzureRM::File] A file. Return nil if the file does not exist.
        #
        def get(key, options = {}, &block)
          requires :directory

          blob, content = service.get_blob(directory.key, key, options, &block)
          data = parse_storage_object(blob)
          file_data = data.merge(
            body: content,
            key: key
          )
          new(file_data)
        rescue => error
          return nil if error.message == 'NotFound'
          raise error
        end

        # Get the URL of the file(blob) with the given name.
        #
        #     required attributes: directory
        #
        # @param key     [String] Name of file
        # @param expires [Time] The time at which the shared access signature becomes invalid, in a UTC format.
        # @param options [Hash]
        # @option options [String] scheme Sets which URL to get, http or https. Options: https or http. Default is https.
        #
        # @return [String] A URL.
        #
        def get_url(key, expires, options = {})
          requires :directory

          if options[:scheme] == 'http'
            get_http_url(key, expires, options)
          else
            get_https_url(key, expires, options)
          end
        end

        # Get the http URL of the file(blob) with the given name.
        #
        #     required attributes: directory
        #
        # @param key     [String] Name of file
        # @param expires [Time] The time at which the shared access signature becomes invalid, in a UTC format.
        # @param options [Hash] Unused. To keep same interface as other providers.
        #
        # @return [String] A http URL.
        #
        def get_http_url(key, expires, _options = {})
          requires :directory

          service.get_blob_http_url(directory.key, key, expires)
        end

        # Get the https URL of the file(blob) with the given name.
        #
        #     required attributes: directory
        #
        # @param key     [String] Name of file
        # @param expires [Time] The time at which the shared access signature becomes invalid, in a UTC format.
        # @param options [Hash] Unused. To keep same interface as other providers.
        #
        # @return [String] A https URL.
        #
        def get_https_url(key, expires, _options = {})
          requires :directory

          service.get_blob_https_url(directory.key, key, expires)
        end

        # Get the file(blob) without content with the given name.
        #
        #     required attributes: directory
        #
        # @param key     [String] Name of file
        # @param options [Hash]
        #
        # @return [Fog::Storage::AzureRM::File] A file. Return nil if the file does not exist.
        #
        def head(key, options = {})
          requires :directory

          blob = service.get_blob_properties(directory.key, key, options)
          data = parse_storage_object(blob)
          file_data = data.merge(key: key)
          new(file_data)
        rescue => error
          return nil if error.message == 'NotFound'
          raise error
        end

        # Create a new file.
        #
        #     required attributes: directory
        #
        # @return [Fog::Storage::AzureRM::File] A file. You need to use File.save to upload this new file.
        #
        def new(attributes = {})
          requires :directory

          super({ directory: directory }.merge!(attributes))
        end
      end
    end
  end
end
