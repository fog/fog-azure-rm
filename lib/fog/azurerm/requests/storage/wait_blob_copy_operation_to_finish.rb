module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def wait_blob_copy_operation_to_finish(container_name, blob_name, copy_id, copy_status, timeout = nil)
          begin
            start_time = Time.new
            while copy_status == COPY_STATUS[:PENDING]
              blob = get_blob_properties(container_name, blob_name)
              blob_props = blob.properties
              if !copy_id.nil? && blob_props[:copy_id] != copy_id
                raise "The progress of copying to #{container_name}/#{blob_name} was interrupted by other copy operations."
              end

              copy_status_description = blob_props[:copy_status_description]
              copy_status = blob_props[:copy_status]
              break if copy_status != COPY_STATUS[:PENDING]

              elapse_time = Time.new - start_time
              raise Timeout::Error.new("The copy operation cannot be finished in #{timeout} seconds") if !timeout.nil? && elapse_time >= timeout

              copied_bytes, total_bytes = blob_props[:copy_progress].split('/').map(&:to_i)
              interval = copied_bytes.zero? ? 5 : (total_bytes - copied_bytes).to_f / copied_bytes * elapse_time
              interval = 30 if interval > 30
              interval = 1 if interval < 1
              sleep(interval)
            end

            if copy_status != COPY_STATUS[:SUCCESS]
              raise "Failed to copy to #{container_name}/#{blob_name}: \n\tcopy status: #{copy_status}\n\tcopy description: #{copy_status_description}"
            end
          rescue
            # Abort the copy & reraise
            begin
              delete_blob(container_name, blob_name)
            rescue => ex
              Fog::Logger.debug "Cannot delete the blob: #{container_name}/#{blob_name} after the copy operation failed. #{ex.inspect}"
            end
            raise
          end

          Fog::Logger.debug "Successfully copied the blob: #{container_name}/#{blob_name}."
          true
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def wait_blob_copy_operation_to_finish(*)
          true
        end
      end
    end
  end
end
