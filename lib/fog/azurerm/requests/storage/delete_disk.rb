module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def delete_disk(blob_name)
          msg = "Deleting Disk: #{blob_name}."
          Fog::Logger.debug msg
          begin
            result = delete_blob('vhds', "#{blob_name}.vhd")
          rescue Azure::Core::Http::HTTPError => e
            raise_azure_exception(e, msg)
          end
          if result.nil?
            Fog::Logger.debug "Successfully deleted Disk: #{blob_name}."
            true
          else
            Fog::Logger.debug 'Error deleting Disk.'
            false
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def delete_disk(*)
          Fog::Logger.debug 'Deleting Disk: test_blob.'
          Fog::Logger.debug 'Successfully deleted Disk: test_blob.'
          true
        end
      end
    end
  end
end
