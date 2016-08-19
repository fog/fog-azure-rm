module Fog
  module Network
    class AzureRM
      # Mock class for Network Request
      class Real
        def check_for_virtual_network(resource_group, name)
          begin
            @network_client.virtual_networks.get(resource_group, name)
            return true
          rescue MsRestAzure::AzureOperationError => e
            raise Fog::AzureRm::OperationError.new(e) if e.body['error']['code'] == 'ResourceGroupNotFound'
            return false if e.body['error']['code'] == 'ResourceNotFound'
          end
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
