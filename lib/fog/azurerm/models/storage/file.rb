module Fog
  module Storage
    class AzureRM
      # This class is giving implementation of create/save and
      # delete/destroy for Blob.
      class File < Fog::Model
        identity :key, aliases: %w(Name name Key)

        attr_writer :body
        attribute :directory
        attribute :accept_ranges,           aliases: %w(Accept-Ranges AcceptRanges)
        attribute :content_length,          aliases: %w(Content-Length Size), type: :integer
        attribute :content_type,            aliases: %w(Content-Type ContentType)
        attribute :content_md5,             aliases: %w(Content-MD5 ContentMD5)
        attribute :content_encoding,        aliases: %w(Content-Encoding ContentEncoding)
        attribute :content_language,        aliases: %w(Content-Language ContentLanguage)
        attribute :cache_control,           aliases: %w(Cache-Control CacheControl)
        attribute :content_disposition,     aliases: %w(Content-Disposition ContentDisposition)
        attribute :copy_completion_time,    aliases: %w(Copy-Completion-Time CopyCompletionTime)
        attribute :copy_status,             aliases: %w(Copy-Status CopyStatus)
        attribute :copy_status_description, aliases: %w(Copy-Status-Description CopyStatusDescription)
        attribute :copy_id,                 aliases: %w(Copy-Id CopyId)
        attribute :copy_progress,           aliases: %w(Copy-Progress CopyProgress)
        attribute :copy_source,             aliases: %w(Copy-Source CopySource)
        attribute :etag,                    aliases: %w(Etag ETag)
        attribute :last_modified,           aliases: %w(Last-Modified LastModified), type: 'time'
        attribute :lease_duration,          aliases: %w(Lease-Duration LeaseDuration)
        attribute :lease_state,             aliases: %w(Lease-State LeaseState)
        attribute :lease_status,            aliases: %w(Lease-Status LeaseStatus)
        attribute :sequence_number,         aliases: %w(Sequence-Number SequenceNumber)
        attribute :blob_type,               aliases: %w(Blob-Type BlobType)
        attribute :metadata

        # Save the file to the directory in Azure storage.
        # TODO: Support snapshots.
        #
        #     required attributes: body(Only if update_body is true), directory, key
        #
        # @param identity [String] Name of directory
        # @param options  [Hash]
        # @option options [Boolean] update_body        Sets whether to upload the body of the file. Default is true.
        #                                              Will update metadata and properties when update_body is set to false.
        # @option options [Integer] worker_thread_num  Sets how many threads will be used to upload the body. Default is 8.
        # @option options [String] blob_type or
        #                          Blob-Type           Sets blob type for the file. Options: 'BlockBlob' or 'PageBlob'. Default is 'BlockBlob'.
        # @option options [String] content_type or
        #                          Content-Type        Sets content type for the file. For example, 'text/plain'.
        # @option options [String] content_md5 or
        #                          Content-MD5         Sets content MD5 hash for the file. Only for store.
        #                                              When a block file whose size <= 32 MB, Azure will verify the integrity of the blob during transport.
        #                                              Please reference this issue: https://github.com/Azure/azure-storage-ruby/issues/64
        # @option options [String] content_encoding or
        #                          Content-Encoding    Sets content encoding for the file. For example, 'x-gzip'.
        # @option options [String] content_language or
        #                          Content-Language    Sets the natural languages used by the file.
        # @option options [String] cache_control or
        #                          Cache-Control       Sets content encoding for the file. For example, 'No-cache'.
        # @option options [String] content_disposition or
        #                          Content-Disposition Sets content disposition for the file. For exampple, 'attachment; filename=testing.txt'.
        # @option options [Hash]   metadata            Sets custom metadata values to store with the file.
        #
        # @return [Boolean]
        #
        def save(options = {})
          update_body = options.delete(:update_body)
          update_body = true if update_body.nil?
          requires :directory, :key
          raise ArgumentError.new('body is required when update_body is true') if update_body && attributes[:body].nil?

          remap_attributes(
            options,
            'Blob-Type'           => :blob_type,
            'Content-Type'        => :content_type,
            'Content-MD5'         => :content_md5,
            'Content-Encoding'    => :content_encoding,
            'Content-Language'    => :content_language,
            'Cache-Control'       => :cache_control,
            'Content-Disposition' => :content_disposition
          )
          options = {
            blob_type: blob_type,
            content_type: content_type,
            content_md5: content_md5,
            content_encoding: content_encoding,
            content_language: content_language,
            cache_control: cache_control,
            content_disposition: content_disposition,
            metadata: metadata
          }.merge!(options)
          options = options.reject { |_key, value| value.nil? || value.to_s.empty? }

          if update_body
            blob = save_blob(options)

            data = parse_storage_object(blob)
            merge_attributes(data)
            attributes[:content_length] = Fog::Storage.get_body_size(body)
            attributes[:content_type] ||= Fog::Storage.get_content_type(body)
          else
            service.put_blob_metadata(directory.key, key, options[:metadata]) if options[:metadata]
            options.delete(:metadata)
            service.put_blob_properties(directory.key, key, options)

            blob = service.get_blob_properties(directory.key, key)
            data = parse_storage_object(blob)
            merge_attributes(data)
          end

          true
        end

        # Get file's body if exists, else ''.
        #
        # @return [File || String]
        #
        def body
          return attributes[:body] if attributes[:body]
          return '' unless last_modified

          file = collection.get(identity)
          if file.nil?
            attributes[:body] = ''
            return ''
          end

          attributes[:body] = file.body
        end

        # Set body attribute.
        #
        # @param new_body [File || String]
        #
        # @return [File || String]
        #
        def body=(new_body)
          attributes[:body] = new_body
        end

        # Copy object from one container to other container.
        #
        #     required attributes: directory, key
        #
        # @param target_directory_key [String]
        # @param target_file_key      [String]
        # @param options              [Hash] options for copy_object method
        # @option options [Integer] timeout Sets to raise a TimeoutError if the copy does not finish in timeout seconds.
        #
        # @return [Fog::Storage::AzureRM::File] New File.
        #
        def copy(target_directory_key, target_file_key, options = {})
          requires :directory, :key

          timeout = options.delete(:timeout)
          copy_id, copy_status = service.copy_blob(target_directory_key, target_file_key, directory.key, key, options)
          service.wait_blob_copy_operation_to_finish(target_directory_key, target_file_key, copy_id, copy_status, timeout)

          target_directory = service.directories.new(key: target_directory_key)
          target_directory.files.head(target_file_key)
        end

        # Copy object from a uri.
        #
        #     required attributes: directory, key
        #
        # @param source_uri [String]
        # @param options    [Hash] options for copy_object method
        # @option options [Integer] timeout Sets to raise a TimeoutError if the copy does not finish in timeout seconds.
        #
        # @return [Boolean]
        #
        def copy_from_uri(source_uri, options = {})
          requires :directory, :key

          timeout = options.delete(:timeout)
          copy_id, copy_status = service.copy_blob_from_uri(directory.key, key, source_uri, options)
          service.wait_blob_copy_operation_to_finish(directory.key, key, copy_id, copy_status, timeout)

          blob = service.get_blob_properties(directory.key, key)
          data = parse_storage_object(blob)
          merge_attributes(data)

          true
        end

        # Destroy file.
        #
        #     required attributes: directory, key
        #
        # @param options [Hash]
        # @option options versionId []
        #
        # @return [Boolean] true if successful
        #
        def destroy(options = {})
          requires :key
          requires :directory
          attributes[:body] = nil
          service.delete_blob(directory.key, key, options)

          true
        end

        # Get whether the file can be accessed by anonymous.
        #
        # @return [Boolean]
        #
        def public?
          requires :directory

          # TBD: The blob can be accessed if read permision is set in one access policy of the container.
          directory.acl == 'container' || directory.acl == 'blob'
        end

        # Get publicly accessible url.
        #
        #     required attributes: directory, key
        #
        # @param options [Hash]
        # @option options [String] scheme Sets which URL to get, http or https. Options: https or http. Default is https.
        #
        # @return [String] A public url.
        #
        def public_url(options = {})
          requires :directory, :key
          options[:scheme] == 'https' if options[:scheme].nil?
          @service.get_blob_url(directory.key, key, options) if public?
        end

        # Get a url for file.
        #
        #     required attributes: key
        #
        # @param expires [Time] The time at which the shared access signature becomes invalid, in a UTC format.
        # @param options [Hash]
        # @option options [String] scheme Sets which URL to get, http or https. Options: https or http. Default is https.
        #
        # @return [String] A public url which will expire after the specified time.
        #
        def url(expires, options = {})
          requires :key
          collection.get_url(key, expires, options)
        end

        private

        # Upload blob
        def save_blob(options)
          if options[:blob_type].nil? || options[:blob_type] == 'BlockBlob'
            if Fog::Storage.get_body_size(body) <= SINGLE_BLOB_PUT_THRESHOLD
              service.create_block_blob(directory.key, key, body, options)
            else
              service.multipart_save_block_blob(directory.key, key, body, options)
              service.get_blob_properties(directory.key, key)
            end
          else
            service.save_page_blob(directory.key, key, body, options)
            service.get_blob_properties(directory.key, key)
          end
        end
      end
    end
  end
end
