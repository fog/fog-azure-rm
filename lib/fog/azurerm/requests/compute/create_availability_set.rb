FAULT_DOMAIN_COUNT = 3
UPDATE_DOMAIN_COUNT = 5

module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def create_availability_set(resource_group, name, location)
          log_message = "Creating Availability Set '#{name}' in #{location} region."
          Fog::Logger.debug log_message
          avail_set_params = get_availability_set_properties(location)
          begin
            availability_set = @compute_mgmt_client.availability_sets.create_or_update(resource_group, name, avail_set_params)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, log_message)
          end
          Fog::Logger.debug "Availability Set #{name} created successfully."
          availability_set
        end

        # create the properties object for creating availability sets
        def get_availability_set_properties(location)
          avail_set = Azure::ARM::Compute::Models::AvailabilitySet.new
          avail_set.platform_fault_domain_count = FAULT_DOMAIN_COUNT
          avail_set.platform_update_domain_count = UPDATE_DOMAIN_COUNT
          avail_set.virtual_machines = []
          avail_set.statuses = []
          avail_set.location = location
          avail_set
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def create_availability_set(resource_group, name, location)
          {
            'location' => location,
            'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Compute/availabilitySets/#{name}",
            'name' => name,
            'type' => 'Microsoft.Compute/availabilitySets',
            'properties' =>
            {
              'platformUpdateDomainCount' => FAULT_DOMAIN_COUNT,
              'platformFaultDomainCount' => FAULT_DOMAIN_COUNT
            }
          }
        end
      end
    end
  end
end
