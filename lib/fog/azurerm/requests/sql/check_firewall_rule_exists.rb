module Fog
  module Sql
    class AzureRM
      # Mock class for Sql Request
      class Real
        def check_firewall_rule_exists(resource_group, server_name, rule_name)
          msg = "Checking Firewall Rule #{rule_name}"
          Fog::Logger.debug msg
          # This module needs to be updated to azure sdk
        end
      end

      # Mock class for Sql Request
      class Mock
        def check_firewall_rule_exists(*)
          true
        end
      end
    end
  end
end
