module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def delete_network_security_rule(resource_group, network_security_group_name, security_rule_name)
          msg = "Deleting Network Security Rule #{security_rule_name} in Security Group #{network_security_group_name}"
          Fog::Logger.debug msg

          begin
            @network_client.security_rules.delete(resource_group, network_security_group_name, security_rule_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end

          Fog::Logger.debug "Network Security Rule #{security_rule_name} deleted successfully."
          true
        end
      end

      # Mock class for Network Request
      class Mock
        def delete_network_security_rule(*)
          Fog::Logger.debug 'Network Security Rule test-security-rule from Resource group test-rg deleted successfully.'
          true
        end
      end
    end
  end
end
