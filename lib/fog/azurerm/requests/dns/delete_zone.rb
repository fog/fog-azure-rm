module Fog
  module DNS
    class AzureRM
      # Real class for DNS Request
      class Real
        def delete_zone(resource_group, name)
          msg = "Deleting Zone #{name} from Resource Group #{resource_group}."
          Fog::Logger.debug msg
          begin
            @dns_client.zones.delete(resource_group, name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Zone #{name} Deleted Successfully."
          true
        end
      end

      # Mock class for DNS Request
      class Mock
        def delete_zone(*)
          Fog::Logger.debug 'Zone deleted successfully.'
          true
        end
      end
    end
  end
end
