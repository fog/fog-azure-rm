module Fog
  module Sql
    class AzureRM
      # Mock class for Sql Request
      class Real
        def check_database_exists(resource_group, server_name, name)
          msg = "Checking SQL Database #{name}"
          Fog::Logger.debug msg
          # This module needs to be updated to azure sdk
        end
      end

      # Mock class for Sql Request
      class Mock
        def check_database_exists(*)
          true
        end
      end
    end
  end
end
