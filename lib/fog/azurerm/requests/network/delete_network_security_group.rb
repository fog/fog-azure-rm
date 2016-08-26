module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def delete_network_security_group(resource_group, name)
          msg = "Deleting Network Security Group: #{name}"
          Fog::Logger.debug msg

          begin
            @network_client.network_security_groups.delete(resource_group, name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end

          Fog::Logger.debug "Network Security Group #{name} deleted successfully."
          true
        end
      end

      # Mock class for Network Request
      class Mock
        def delete_network_security_group(resource_group, name)
          Fog::Logger.debug "Network Security Group #{name} from Resource group #{resource_group} deleted successfully."
          true
        end
      end
    end
  end
end
