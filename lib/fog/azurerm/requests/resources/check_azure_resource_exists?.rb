module Fog
  module Resources
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def check_azure_resource_exists?(resource_id, api_version)
          split_resource = resource_id.split('/') unless resource_id.nil?
          raise 'Invalid Resource Id' if split_resource.count != 9

          resource_group_name = get_resource_from_resource_id(resource_id, RESOURCE_GROUP_NAME)
          resource_provider_namespace = get_resource_from_resource_id(resource_id, RESOURCE_PROVIDER_NAMESPACE)
          resource_type = get_resource_from_resource_id(resource_id, RESOURCE_TYPE)
          resource_name = get_resource_from_resource_id(resource_id, RESOURCE_NAME)
          parent_resource_id = ''

          msg = "Checking Resource #{resource_name}"
          Fog::Logger.debug msg
          begin
            @rmc.resources.check_existence(resource_group_name, resource_provider_namespace, parent_resource_id, resource_type, resource_name, api_version)
            Fog::Logger.debug "Resource #{resource_name} exists."
            true
          rescue MsRestAzure::AzureOperationError => e
            if e.response.status == 405
              Fog::Logger.debug "Resource #{resource_name} doesn't exist."
              false
            else
              raise_azure_exception(e, msg)
            end
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def check_azure_resource_exists?(*)
          true
        end
      end
    end
  end
end
