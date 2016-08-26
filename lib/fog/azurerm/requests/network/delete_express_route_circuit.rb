module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def delete_express_route_circuit(resource_group_name, circuit_name)
          msg = "Deleting Express Route Circuit #{circuit_name} from Resource Group #{resource_group_name}."
          Fog::Logger.debug msg
          begin
            @network_client.express_route_circuits.delete(resource_group_name, circuit_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Express Route Circuit #{circuit_name} Deleted Successfully."
          true
        end
      end

      # Mock class for Network Request
      class Mock
        def delete_express_route_circuit(*)
          Fog::Logger.debug 'Express Route Circuit {circuit_name} from Resource group {resource_group_name} deleted successfully.'
          true
        end
      end
    end
  end
end
