module Fog
  module Network
    class AzureRM
      # Mock class for Network Request
      class Real
        def check_virtual_network_exists(resource_group, name)
          msg = "Checking Virtual Network #{name}"
          Fog::Logger.debug msg
          begin
            @network_client.virtual_networks.get(resource_group, name)
            Fog::Logger.debug "Virtual Network #{name} exists."
            true
          rescue MsRestAzure::AzureOperationError => e
            if e.body['error']['code'] == 'ResourceNotFound'
              Fog::Logger.debug "Virtual Network #{name} doesn't exist."
              false
            else
              raise_azure_exception(e, msg)
            end
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def check_virtual_network_exists(resource_group, name)
          Fog::Logger.debug "Virtual Network #{name} from Resource group #{resource_group} is available."
          true
        end
      end
    end
  end
end
