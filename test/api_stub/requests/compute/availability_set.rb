module ApiStub
  module Requests
    module Compute
      # Mock class for Availability Set Requests
      class AvailabilitySet
        def self.create_unmanaged_availability_set_response(compute_client)
          body = '{
                    "id":"/subscriptions/{subscription-id}/resourceGroups/myrg1/providers/Microsoft.Compute/availabilitySets/avset1",
                    "name":"myavset1",
                    "type":"Microsoft.Compute/availabilitySets",
                    "location":"westus",
                    "tags": {},
                    "platformUpdateDomainCount": 5,
                    "platformFaultDomainCount": 2,
                    "virtualMachines":[],
                    "sku":{
                      "name":"Classic"
                    }
                  }'
          availability_set_mapper = Azure::Compute::Profiles::Latest::Mgmt::Models::AvailabilitySet.mapper
          compute_client.deserialize(availability_set_mapper, Fog::JSON.decode(body), 'result.body')
        end

        def self.create_managed_availability_set_response(compute_client)
          body = '{
                    "id":"/subscriptions/{subscription-id}/resourceGroups/myrg1/providers/Microsoft.Compute/availabilitySets/avset1",
                    "name":"myavset1",
                    "type":"Microsoft.Compute/availabilitySets",
                    "location":"westus",
                    "tags": {},
                    "platformUpdateDomainCount": 5,
                    "platformFaultDomainCount": 2,
                    "virtualMachines":[],
                    "sku":{
                      "name":"Aligned"
                    }
                  }'
          availability_set_mapper = Azure::Compute::Profiles::Latest::Mgmt::Models::AvailabilitySet.mapper
          compute_client.deserialize(availability_set_mapper, Fog::JSON.decode(body), 'result.body')
        end

        def self.create_availability_set_response(compute_client)
          body = '{
                    "id":"/subscriptions/{subscription-id}/resourceGroups/myrg1/providers/Microsoft.Compute/availabilitySets/avset1",
                    "name":"myavset1",
                    "type":"Microsoft.Compute/availabilitySets",
                    "location":"westus",
                    "tags": {},
                    "platformUpdateDomainCount": 5,
                    "platformFaultDomainCount": 2,
                    "virtualMachines":[]
                  }'
          availability_set_mapper = Azure::Compute::Profiles::Latest::Mgmt::Models::AvailabilitySet.mapper
          compute_client.deserialize(availability_set_mapper, Fog::JSON.decode(body), 'result.body')
        end

        def self.create_custom_availability_set_response(compute_client)
          body = '{
                    "id":"/subscriptions/{subscription-id}/resourceGroups/myrg1/providers/Microsoft.Compute/availabilitySets/avset1",
                    "name":"myavset1",
                    "type":"Microsoft.Compute/availabilitySets",
                    "location":"westus",
                    "tags": {},
                    "platformUpdateDomainCount": 10,
                    "platformFaultDomainCount": 3,
                    "virtualMachines":[]
                  }'
          availability_set_mapper = Azure::Compute::Profiles::Latest::Mgmt::Models::AvailabilitySet.mapper
          compute_client.deserialize(availability_set_mapper, Fog::JSON.decode(body), 'result.body')
        end

        def self.list_availability_set_response(sdk_compute_client)
          body = '{
             "value": [ {
                    "id":"/subscriptions/{subscription-id}/resourceGroups/myrg1/providers/Microsoft.Compute/availabilitySets/avset1",
                    "name":"myavset1",
                    "type":"Microsoft.Compute/availabilitySets",
                    "location":"westus",
                    "tags": {},
                    "platformUpdateDomainCount":5,
                    "platformFaultDomainCount":2,
                    "virtualMachines":[],
                    "sku":{
                      "name":"Classic"
                    }
              } ]
          }'
          availability_set_mapper = Azure::Compute::Profiles::Latest::Mgmt::Models::AvailabilitySetListResult.mapper
          sdk_compute_client.deserialize(availability_set_mapper, Fog::JSON.decode(body), 'result.body')
        end

        def self.get_availability_set_response(sdk_compute_client)
          body = '{
             "value": [ {
                    "id":"/subscriptions/{subscription-id}/resourceGroups/myrg1/providers/Microsoft.Compute/availabilitySets/avset1",
                    "name":"myavset1",
                    "type":"Microsoft.Compute/availabilitySets",
                    "location":"westus",
                    "tags": {},
                    "platformUpdateDomainCount":5,
                    "platformFaultDomainCount":2,
                    "virtualMachines":[],
                    "sku":{
                      "name":"Classic"
                    }
              } ]
          }'
          availability_set_mapper = Azure::Compute::Profiles::Latest::Mgmt::Models::AvailabilitySet.mapper
          sdk_compute_client.deserialize(availability_set_mapper, Fog::JSON.decode(body), 'result.body')
        end
      end
    end
  end
end
