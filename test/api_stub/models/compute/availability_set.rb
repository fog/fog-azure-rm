UPDATE_DOMAIN_COUNT = 5
FAULT_DOMAIN_COUNT = 3

module ApiStub
  module Models
    module Compute
      # Mock class for Availability Set Model
      class AvailabilitySet
        def self.create_availability_set_response(sdk_compute_client)
          avail_set = {
            'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Compute/availabilitySets/fog-test-availability-set',
            'name' => 'fog-test-availability-set',
            'type' => 'Microsoft.Compute/availabilitySets',
            'location' => 'westus',
            'platformUpdateDomainCount' => UPDATE_DOMAIN_COUNT,
            'platformFaultDomainCount' => FAULT_DOMAIN_COUNT

          }
          result_mapper = Azure::ARM::Compute::Models::AvailabilitySet.mapper
          sdk_compute_client.deserialize(result_mapper, avail_set, 'result.body')
        end

        def self.list_availability_set_response(sdk_compute_client)
          avail_set = {
              'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Compute/availabilitySets/fog-test-availability-set',
              'name' => 'fog-test-availability-set',
              'type' => 'Microsoft.Compute/availabilitySets',
              'location' => 'westus',
              'platformUpdateDomainCount' => UPDATE_DOMAIN_COUNT,
              'platformFaultDomainCount' => FAULT_DOMAIN_COUNT

          }
          result_mapper = Azure::ARM::Compute::Models::AvailabilitySet.mapper
          sdk_compute_client.deserialize(result_mapper, avail_set, 'result.body')
        end

        def self.get_availability_set_response(sdk_compute_client)
          avail_set = {
              'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Compute/availabilitySets/fog-test-availability-set',
              'name' => 'fog-test-availability-set',
              'type' => 'Microsoft.Compute/availabilitySets',
              'location' => 'westus',
              'platformUpdateDomainCount' => UPDATE_DOMAIN_COUNT,
              'platformFaultDomainCount' => FAULT_DOMAIN_COUNT

          }
          result_mapper = Azure::ARM::Compute::Models::AvailabilitySet.mapper
          sdk_compute_client.deserialize(result_mapper, avail_set, 'result.body')
        end
      end
    end
  end
end
