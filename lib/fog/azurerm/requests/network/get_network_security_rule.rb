module Fog
  module Network
    class AzureRM
      # Real class for Network Security rule Request
      class Real
        def get_network_security_rule(resource_group_name, network_security_group_name, security_rule_name)
          msg = "Getting Network Security Rule #{security_rule_name} from Resource Group #{resource_group_name}."
          Fog::Logger.debug msg

          begin
            security_rule = @network_client.security_rules.get(resource_group_name, network_security_group_name, security_rule_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end

          Fog::Logger.debug "Network Security Rule #{security_rule_name} retrieved successfully."
          security_rule
        end
      end
      class Mock
      end
    end
  end
end
