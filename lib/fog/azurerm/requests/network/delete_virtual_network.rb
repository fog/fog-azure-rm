module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def delete_virtual_network(resource_group, name)
          Fog::Logger.debug "Deleting Virtual Network: #{name}..."
          begin
            @network_client.virtual_networks.delete(resource_group, name)
            Fog::Logger.debug "Virtual Network #{name} deleted successfully."
            true
          rescue MsRestAzure::AzureOperationError => e
            raise Fog::AzureRm::OperationError.new(e)
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def delete_virtual_network(resource_group, name)
          Fog::Logger.debug "Virtual Network #{name} from Resource group #{resource_group} deleted successfully."
          true
        end
      end
    end
  end
end
