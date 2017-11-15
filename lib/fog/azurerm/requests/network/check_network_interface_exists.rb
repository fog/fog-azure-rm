module Fog
  module Network
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def check_network_interface_exists(resource_group_name, nic_name)
          msg = "Checking Network Interface #{nic_name}"
          Fog::Logger.debug msg
          begin
            @network_client.network_interfaces.get(resource_group_name, nic_name)
            Fog::Logger.debug "Network Interface #{nic_name} exists."
            true
          rescue MsRestAzure::AzureOperationError => e
            if check_resource_existence_exception(e)
              raise_azure_exception(e, msg)
            else
              Fog::Logger.debug "Network Interface #{nic_name} doesn't exist."
              false
            end
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def check_network_interface_exists(*)
          true
        end
      end
    end
  end
end
