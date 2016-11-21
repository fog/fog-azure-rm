module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        # Create a disk in Azure storage.
        #
        # @param disk_name [String] Name of disk
        # @param disk_size_in_gb [Integer] Disk size in GiB. Value range: [1, 1023]
        # @param options  [Hash]
        # @option options [String] container_name Sets name of the container which contains the disk. Default is 'vhds'.
        #
        # @return [Boolean]
        #
        def create_disk(disk_name, disk_size_in_gb, options = {})
          msg = "Creating disk(#{disk_name}, #{disk_size_in_gb}). options: #{options}"
          Fog::Logger.debug msg

          raise ArgumentError, "disk_size_in_gb #{disk_size_in_gb} must be an integer" unless disk_size_in_gb.is_a?(Integer)
          raise ArgumentError, "Azure minimum disk size is 1 GiB: #{disk_size_in_gb}" if disk_size_in_gb < 1
          raise ArgumentError, "Azure maximum disk size is 1023 GiB: #{disk_size_in_gb}" if disk_size_in_gb > 1023

          container_name = options.delete(:container_name)
          container_name = 'vhds' if container_name.nil?
          blob_name = "#{disk_name}.vhd"
          vhd_size = disk_size_in_gb * 1024 * 1024 * 1024
          blob_size = vhd_size + 512

          opts = {
            type:   :fixed,
            name: '/tmp/footer.vhd', # Only used to initialize vhd, no local file is generated.
            size: disk_size_in_gb
          }
          vhd_footer = Vhd::Library.new(opts).footer.values.join

          begin
            create_page_blob(container_name, blob_name, blob_size, options)
            put_blob_pages(container_name, blob_name, vhd_size, blob_size - 1, vhd_footer, options)
          rescue
            begin
              delete_blob(container_name, blob_name)
            rescue => ex
              Fog::Logger.debug "Cannot delete the blob: #{container_name}/#{blob_name} after create_disk failed. #{ex.inspect}"
            end
            raise
          end

          Fog::Logger.debug "Created a disk #{disk_name} successfully."
          true
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def create_disk(*)
          Fog::Logger.debug 'Disk created successfully.'
          true
        end
      end
    end
  end
end
