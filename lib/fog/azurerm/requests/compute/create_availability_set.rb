module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def create_availability_set(resource_group, name, location)
          Fog::Logger.debug "Creating Availability Set '#{name}' in #{location} region."
          begin
            avail_set_params = get_avail_set_properties(location)
            avail_set = @compute_mgmt_client.availability_sets.create_or_update(resource_group, name, avail_set_params)
          rescue MsRestAzure::AzureOperationError => e
            raise Fog::AzureRm::OperationError.new(e)
          end
          Fog::Logger.debug "Availability Set #{name} created successfully."
          avail_set
        end

        # create the properties object for creating availability sets
        def get_avail_set_properties(location)
          avail_set = Azure::ARM::Compute::Models::AvailabilitySet.new
          avail_set.platform_fault_domain_count = 2
          avail_set.platform_update_domain_count = 2
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
              'platformUpdateDomainCount' => 2,
              'platformFaultDomainCount' => 2
            }
          }
        end
      end
    end
  end
end
