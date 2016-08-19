module ApiStub
  module Requests
    module Compute
      # Mock class for Availability Set Requests
      class AvailabilitySet
        def self.create_availability_set_response(client)
          body = '{
                    "id":"/subscriptions/{subscription-id}/resourceGroups/myrg1/providers/Microsoft.Compute/availabilitySets/avset1",
                    "name":"myavset1",
                    "type":"Microsoft.Compute/availabilitySets",
                    "location":"westus",
                    "tags": {},
                    "platformUpdateDomainCount":5,
                    "platformFaultDomainCount":3,
                    "virtualMachines":[]
                  }'
          result_mapper = Azure::ARM::Compute::Models::AvailabilitySet.mapper
          client.deserialize(result_mapper, JSON.load(body), 'result.body')
        end

        def self.list_availability_set_response(client)
          body = '{
             "value": [ {
                    "id":"/subscriptions/{subscription-id}/resourceGroups/myrg1/providers/Microsoft.Compute/availabilitySets/avset1",
                    "name":"myavset1",
                    "type":"Microsoft.Compute/availabilitySets",
                    "location":"westus",
                    "tags": {},
                    "platformUpdateDomainCount":5,
                    "platformFaultDomainCount":3,
                    "virtualMachines":[]
              } ]
          }'
          result_mapper = Azure::ARM::Compute::Models::AvailabilitySetListResult.mapper
          client.deserialize(result_mapper, JSON.load(body), 'result.body')
        end

        def self.get_availability_set_response(client)
          body = '{
             "value": [ {
                    "id":"/subscriptions/{subscription-id}/resourceGroups/myrg1/providers/Microsoft.Compute/availabilitySets/avset1",
                    "name":"myavset1",
                    "type":"Microsoft.Compute/availabilitySets",
                    "location":"westus",
                    "tags": {},
                    "platformUpdateDomainCount":5,
                    "platformFaultDomainCount":3,
                    "virtualMachines":[]
              } ]
          }'
          result_mapper = Azure::ARM::Compute::Models::AvailabilitySet.mapper
          client.deserialize(result_mapper, JSON.load(body), 'result.body')
        end
      end
    end
  end
end
