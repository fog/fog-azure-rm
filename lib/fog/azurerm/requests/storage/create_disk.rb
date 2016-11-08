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
          ::File.open('out.txt', 'w') { |f| f.write('Sample File') }
          path = ::File.expand_path(::File.dirname('out.txt')) + '/' + 'out.txt'
          create_page_blob('vhds', "#{blob_name}.vhd", ::File.size(path))

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
