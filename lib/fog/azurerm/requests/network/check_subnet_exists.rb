module Fog
  module Network
    class AzureRM
      # Mock class for Network Request
      class Real
        def check_subnet_exists(resource_group, virtual_network_name, subnet_name)
          msg = "Checking Subnet #{subnet_name}"
          Fog::Logger.debug msg
          begin
            @network_client.subnets.get(resource_group, virtual_network_name, subnet_name)
            Fog::Logger.debug "Subnet #{subnet_name} exists."
            true
          rescue MsRestAzure::AzureOperationError => e
            if e.body['error']['code'] == 'ResourceNotFound'
              Fog::Logger.debug "Subnet #{subnet_name} doesn't exist."
              false
            else
              raise_azure_exception(e, msg)
            end
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def check_subnet_exists(*)
          true
        end
      end
    end
  end
end
