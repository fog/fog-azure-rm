module Fog
  module DNS
    class AzureRM
      # Real class for DNS Request
      class Real
        def delete_record_set(resource_group, name, zone_name, record_type)
          msg = "Deleting Record Set #{name} from Resource Group #{resource_group}."
          Fog::Logger.debug msg
          begin
            @dns_client.record_sets.delete(resource_group, zone_name, name, record_type)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Record Set #{name} Deleted Successfully."
          true
        end
      end

      # Mock class for DNS Request
      class Mock
        def delete_record_set(*)
          Fog::Logger.debug 'Record Set name deleted successfully.'
          true
        end
      end
    end
  end
end
