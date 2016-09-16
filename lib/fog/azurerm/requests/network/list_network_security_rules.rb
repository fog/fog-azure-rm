module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def list_network_security_rules(resource_group, network_security_group_name)
          msg = "Getting list of Network Security Rule in Security Group #{network_security_group_name} from Resource Group #{resource_group}."
          Fog::Logger.debug msg

          begin
            nsr_list_result = @network_client.security_rules.list_as_lazy(resource_group, network_security_group_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end

          Fog::Logger.debug "Network Security Rules list retrieved successfully from Resource Group #{resource_group}."
          nsr_list_result.value
        end
      end
    end
  end
end
