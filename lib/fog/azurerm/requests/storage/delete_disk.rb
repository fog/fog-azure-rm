module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def delete_disk(disk_name)
          msg = "Deleting Disk: #{disk_name}."
          Fog::Logger.debug msg
          delete_blob('vhds', "#{disk_name}.vhd")
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
