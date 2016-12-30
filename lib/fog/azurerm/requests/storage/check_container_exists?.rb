module Fog
  module Storage
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def check_container_exists?(name)
          msg = "Checking container #{name}."
          Fog::Logger.debug msg
          begin
            get_container_properties(name)
            Fog::Logger.debug "Container #{name} exists."
            true
          rescue Exception => e
            if e.message.include? 'NotFound'
              Fog::Logger.debug "The specified container #{name} does not exist."
              false
            end
          end
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def check_container_exists?(*)
          true
        end
      end
    end
  end
end
