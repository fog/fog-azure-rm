module Fog
  module Network
    class AzureRM
      # Mock class for Network Request
      class Real
        def check_public_ip_exists(resource_group, name)
          msg = "Checking Public IP #{name}"
          Fog::Logger.debug msg
          begin
            @network_client.public_ipaddresses.get(resource_group, name)
            Fog::Logger.debug "Public IP #{name} exists."
            true
          rescue MsRestAzure::AzureOperationError => e
            if check_resource_existence_exception(e)
              raise_azure_exception(e, msg)
            else
              Fog::Logger.debug "Public IP #{name} doesn't exist."
              false
            end
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def check_public_ip_exists(resource_group, name)
          Fog::Logger.debug "Public IP #{name} from Resource group #{resource_group} is available."
          true
        end
      end
    end
  end
end
