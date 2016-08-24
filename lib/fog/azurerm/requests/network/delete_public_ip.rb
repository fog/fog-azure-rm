module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def delete_public_ip(resource_group, name)
          Fog::Logger.debug "Deleting PublicIP #{name} from Resource Group #{resource_group}."
          begin
            @network_client.public_ipaddresses.delete(resource_group, name)
          rescue  MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, "Deleting PublicIP #{name} from Resource Group #{resource_group}")
          end
          Fog::Logger.debug "PublicIP #{name} Deleted Successfully."
          true
        end
      end

      # Mock class for Network Request
      class Mock
        def delete_public_ip(resource_group, name)
          Fog::Logger.debug "Public IP #{name} from Resource group #{resource_group} deleted successfully."
          true
        end
      end
    end
  end
end
