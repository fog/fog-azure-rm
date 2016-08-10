module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def delete_express_route_circuit(resource_group_name, circuit_name)
          Fog::Logger.debug "Deleting Express Route Circuit #{circuit_name} from Resource Group #{resource_group_name}."
          begin
            promise = @network_client.express_route_circuits.delete(resource_group_name, circuit_name)
            promise.value!
            Fog::Logger.debug "Express Route Circuit #{circuit_name} Deleted Successfully."
            true
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Exception deleting Express Route Circuit #{circuit_name} in Resource Group: #{resource_group_name}. #{e.body['error']['message']}"
            raise msg
          end
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
