module Fog
  module Network
    class AzureRM
      # Mock class for Network Request
      class Real
        def check_for_virtual_network(resource_group, name)
          msg = "Finding Virtual Network #{name}"
          Fog::Logger.debug msg
          begin
            @network_client.virtual_networks.get(resource_group, name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg) if e.body['error']['code'] == 'ResourceGroupNotFound'
            return false if e.body['error']['code'] == 'ResourceNotFound'
          end
          return true
        end
      end

      # Mock class for Network Request
      class Mock
        def check_for_virtual_network(resource_group, name)
          Fog::Logger.debug "Virtual Network #{name} from Resource group #{resource_group} is available."
          true
        end
      end
    end
  end
end
