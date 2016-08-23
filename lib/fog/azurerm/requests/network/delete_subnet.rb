module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def delete_subnet(resource_group, name, virtual_network_name)
          Fog::Logger.debug "Deleting Subnet: #{name}..."
          begin
            @network_client.subnets.delete(resource_group, virtual_network_name, name)
            Fog::Logger.debug "Subnet #{name} deleted successfully."
            true
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, "Deleting Subnet: #{name}")
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def delete_subnet(resource_group, name, virtual_network_name)
          Fog::Logger.debug "Subnet #{name} of Virtual Network #{virtual_network_name} from Resource group #{resource_group} deleted successfully."
          true
        end
      end
    end
  end
end
