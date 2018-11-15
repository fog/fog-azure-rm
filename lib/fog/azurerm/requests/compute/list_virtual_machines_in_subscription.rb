module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def list_virtual_machines_in_subscription
          msg = "Listing Virtual Machines in subscription'"
          Fog::Logger.debug msg
          begin
            virtual_machines = @compute_mgmt_client.virtual_machines.list_all
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "listing all Virtual Machines in subscription successful"
          virtual_machines
        end
      end
    end
  end
end
