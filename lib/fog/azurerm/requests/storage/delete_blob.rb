module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def delete_blob(container_name, blob_name, options = {})
          my_options = options.clone
          my_options[:request_id] = SecureRandom.uuid
          
          correlation_id = SecureRandom.uuid
          if !my_options[:fog_correlation_id].nil?
            correlation_id = my_options.delete(:fog_correlation_id)
          end

          msg = "Deleting blob: #{blob_name} in container #{container_name}. options: #{my_options}, correlation id: #{correlation_id}, correlation id: #{correlation_id}."
          Fog::Logger.debug msg

          begin
            @blob_client.delete_blob(container_name, blob_name, my_options)
          rescue Azure::Core::Http::HTTPError => ex
            return true if ex.message.include?('(404)')
            Fog::Logger.warning "Azure error #{e.inspect}, correlation id: #{correlation_id}."
            raise_azure_exception(ex, msg)
          rescue StandardError => e
            Fog::Logger.warning "Unknown error #{e.inspect}, correlation id: #{correlation_id}."
            raise e
          end

          Fog::Logger.debug "Blob #{blob_name} deleted successfully, correlation id: #{correlation_id}."
          true
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def delete_blob(*)
          Fog::Logger.debug 'Blob deleted successfully.'
          true
        end
      end
    end
  end
end
