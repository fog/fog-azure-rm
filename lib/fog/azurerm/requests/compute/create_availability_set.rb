# rubocop:disable AbcSize
# rubocop:disable MethodLength
module Fog
  module Compute
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def create_availability_set(resource_group, name, location)
          begin
            Fog::Logger.debug "Creating Availability Set '#{name}' in #{location} region."
            avail_set_props = get_avail_set_properties(location)
            promise = @compute_mgmt_client.availability_sets.create_or_update(resource_group, name, avail_set_props)
            result = promise.value!
            Fog::Logger.debug "Availability Set #{name} created successfully."
            Azure::ARM::Compute::Models::AvailabilitySet.serialize_object(result.body)
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception creating Availability Set #{name} in Resource Group: #{resource_group}. #{e.body['error']['message']}"
            raise msg
          end
        end

        # create the properties object for creating availability sets
        def get_avail_set_properties(location)
          avail_set_props =
              Azure::ARM::Compute::Models::AvailabilitySetProperties.new
          # At least two domain faults
          avail_set_props.platform_fault_domain_count = 2
          avail_set_props.platform_update_domain_count = 2
          # At this point we do not have virtual machines to include
          avail_set_props.virtual_machines = []
          avail_set_props.statuses = []
          avail_set = Azure::ARM::Compute::Models::AvailabilitySet.new
          avail_set.location = location
          avail_set.properties = avail_set_props
          avail_set
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def create_availability_set(resource_group, name, params)
        end
      end
    end
  end
end
