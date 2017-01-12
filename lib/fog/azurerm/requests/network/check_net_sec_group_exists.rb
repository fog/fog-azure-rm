module Fog
  module Network
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def check_net_sec_group_exists(resource_group_name, security_group_name)
          msg = "Checking Network Security Group #{security_group_name}"
          Fog::Logger.debug msg
          begin
            @network_client.network_security_groups.get(resource_group_name, security_group_name)
            Fog::Logger.debug "Network Security Group #{security_group_name} exists."
            true
          rescue MsRestAzure::AzureOperationError => e
            if e.body['error']['code'] == 'ResourceNotFound'
              Fog::Logger.debug "Network Security Group #{security_group_name} doesn't exist."
              false
            else
              raise_azure_exception(e, msg)
            end
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def check_net_sec_group_exists(*)
          true
        end
      end
    end
  end
end
