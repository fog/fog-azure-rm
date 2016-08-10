module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def delete_express_route_circuit_peering(resource_group_name, peering_name, circuit_name)
          msg = "Deleting Express Route Circuit Peering #{peering_name} from Resource Group #{resource_group_name}."
          Fog::Logger.debug msg
          begin
            @network_client.express_route_circuit_peerings.delete(resource_group_name, circuit_name, peering_name).value!
            Fog::Logger.debug "Express Route Circuit Peering #{peering_name} Deleted Successfully."
            true
          rescue  MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def delete_express_route_circuit_peering(*)
          Fog::Logger.debug 'Express Route Circuit Peering {peering_name} from Resource group {resource_group_name} deleted successfully.'
          true
        end
      end
    end
  end
end
