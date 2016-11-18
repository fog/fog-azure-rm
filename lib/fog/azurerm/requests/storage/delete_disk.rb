module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        # Delete a disk in Azure storage.
        #
        # @param disk_name [String] Name of disk
        # @param options  [Hash]
        # @option options [String] container_name Sets name of the container which contains the disk. Default is 'vhds'.
        #
        # @return [Boolean]
        #
        def delete_disk(disk_name, options = {})
          msg = "Deleting disk(#{disk_name}). options: #{options}"
          Fog::Logger.debug msg

          container_name = options.delete(:container_name)
          container_name = 'vhds' if container_name.nil?
          delete_blob(container_name, "#{disk_name}.vhd")

          Fog::Logger.debug "Successfully deleted Disk: #{disk_name}."
          true
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def delete_disk(*)
          Fog::Logger.debug 'Successfully deleted Disk'
          true
        end
      end
    end
  end
end
