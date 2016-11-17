module Fog
  module Storage
    class AzureRM
      # This class is giving implementation of create and delete a container.
      class Directory < Fog::Model
        VALID_ACLS = ['container', 'blob', 'unknown', nil].freeze

        attr_writer :acl

        identity  :key,                 aliases: %w(Name name)
        attribute :etag,                aliases: %w(Etag ETag)
        attribute :last_modified,       aliases: %w(Last-Modified LastModified), type: 'time'
        attribute :lease_duration,      aliases: %w(Lease-Duration LeaseDuration)
        attribute :lease_state,         aliases: %w(Lease-State LeaseState)
        attribute :lease_status,        aliases: %w(Lease-Status LeaseStatus)

        attribute :metadata

        # Set the the permission
        #
        # @param new_acl [String] permission. Options: container, blob or nil. unknown is for internal usage.
        #                                     container: Full public read access. Container and blob data can be read via anonymous request.
        #                                                Clients can enumerate blobs within the container via anonymous request, but cannot
        #                                                enumerate containers within the storage account.
        #                                     blob: Public read access for blobs only. Blob data within this container can be read via
        #                                           anonymous request, but container data is not available. Clients cannot enumerate blobs
        #                                           within the container via anonymous request.
        #                                     nil: No public read access. Container and blob data can be read by the account owner only.
        #                                     unknown: Internal usage in fog-azure-rm.
        #
        # @return [String] Permission.
        #
        # @exception ArgumentError Raised when new_acl is not 'container', 'blob', nil or 'unknown'.
        #
        # Reference: https://msdn.microsoft.com/en-us/library/azure/dd179391.aspx
        #
        def acl=(new_acl)
          raise ArgumentError.new("acl must be one of [#{VALID_ACLS.join(', ')}nil]") unless VALID_ACLS.include?(new_acl)

          attributes[:acl] = new_acl
        end

        # Get the the permission
        #
        #     required attributes: key
        #
        # @return [String] Permission.
        #
        def acl
          requires :key

          return attributes[:acl] if attributes[:acl] != 'unknown' || !persisted?

          data = service.get_container_acl(key)
          attributes[:acl] = data[0]
        end

        # Destroy directory.
        #
        #     required attributes: key
        #
        # @return [Boolean] True if successful
        #
        def destroy
          requires :key

          service.delete_container(key)
        end

        # Get files under this directory.
        # If you have set max_results or max_keys when getting this directory by directories.get,
        # files may be incomplete. You need to use files.all to get all files under this directory.
        #
        # @return [Fog::Storage::AzureRM::Files] Files.
        #
        def files
          @files ||= Fog::Storage::AzureRM::Files.new(directory: self, service: service)
        end

        # Set the container permission to public or private
        #
        # @param [Boolean] True: public(container); False: private(nil)
        #
        # @return [Boolean] True if public; Otherwise return false.
        #
        def public=(new_public)
          attributes[:acl] = new_public ? 'container' : nil
          new_public
        end

        # Get the public URL of the directory
        #
        #     required attributes: key
        #
        # @param options [Hash]
        # @option options [String] scheme Sets which URL to get, http or https. Options: https or http. Default is https.
        #
        # @return [String] A public URL.
        #
        def public_url(options = {})
          requires :key

          service.get_container_url(key, options) if acl == 'container'
        end

        # Create/Update the directory
        #
        #     required attributes: key
        #
        # @param options [Hash]
        # @option options [Boolean] is_create Sets whether to create or update the directory. Default is true(create).
        #                                     Will update metadata and acl when is_create is set to false.
        #
        # @return [Boolean] True if successful.
        #
        def save(options = {})
          requires :key

          is_create = options.delete(:is_create)
          if is_create.nil? || is_create
            options = {}
            options[:public_access_level] = acl if acl != 'unknown'
            options[:metadata] = metadata if metadata

            container = service.create_container(key, options)
          else
            service.put_container_acl(key, acl) if acl != 'unknown'
            service.put_container_metadata(key, metadata) if metadata
            container = service.get_container_properties(key)
          end

          attributes[:is_persisted] = true
          data = parse_storage_object(container)
          merge_attributes(data)

          true
        end

        # Check whether the directory is created.
        #
        # @return [Boolean] True if the file is created. Otherwise return false.
        #
        def persisted?
          # is_persisted is true in case of directories.get or after #save
          # last_modified is set in case of directories.all
          attributes[:is_persisted] || !attributes[:last_modified].nil?
        end
      end
    end
  end
end
