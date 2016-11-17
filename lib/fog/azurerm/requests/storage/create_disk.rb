module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def create_disk(blob_name, options = {})
          options[:request_id] = SecureRandom.uuid
          msg = "Creating disk(blob) #{blob_name}. options: #{options}"
          Fog::Logger.debug msg

          # TODO: NOT implemented when this file was merged.
          # create_disk(disk_name, disk_size_in_gb, options)
          # require 'vhd'
          # opts = {
          #     :type => :fixed,
          #     :name => "/tmp/footer.vhd", # Only used to initialize Vhd, no local file is generated.
          #     :size => disk_size_in_gb
          # }
          # vhd_footer = Vhd::Library.new(opts).footer.values.join
          # vhd_size = disk_size_in_gb * 1024 * 1024 * 1024
          # blob_size = vhd_size + 512
          # create_page_blob(container_name, blob_name, blob_size, options)
          # put_blob_pages(container_name, blob_name, vhd_size, blob_size - 1, vhd_footer, options)

          Fog::Logger.debug "Create a disk(blob) #{blob_name} successfully."
          true
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def create_disk(*)
          Fog::Logger.debug 'Disk(Blob) created successfully.'
          true
        end
      end
    end
  end
end
