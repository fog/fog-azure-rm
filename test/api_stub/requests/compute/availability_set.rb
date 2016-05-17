module ApiStub
  module Requests
    module Compute
      # Mock class for Availability Set Requests
      class AvailabilitySet
        def self.create_availability_set_response
          body = '{
                 "id":"/subscriptions/{subscription-id}/resourceGroups/myrg1/providers/Microsoft.Compute/availabilitySets/avset1",
                 "name":"myavset1",
                 "type":"Microsoft.Compute/availabilitySets",
                 "location":"westus",
                 "tags": {},
                 "properties": {
                    "platformUpdateDomainCount":5,
                    "platformFaultDomainCount":3,
                    "virtualMachines":[]
                                }
                  }'
          result = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
          result.body = Azure::ARM::Compute::Models::AvailabilitySet.deserialize_object(JSON.load(body))
          result
        end

        def self.list_availability_set_response
          body = '{
             "value": [ {
                 "id":"/subscriptions/{subscription-id}/resourceGroups/myrg1/providers/Microsoft.Compute/availabilitySets/avset1",
                 "name":"myavset1",
                 "type":"Microsoft.Compute/availabilitySets",
                 "location":"westus",
                 "tags": {},
                 "properties": {
                    "platformUpdateDomainCount":5,
                    "platformFaultDomainCount":3,
                    "virtualMachines":[]
                 }
              } ]
          }'
          result = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
          result.body = Azure::ARM::Compute::Models::AvailabilitySetListResult.deserialize_object(JSON.load(body))
          result
        end
      end
    end
  end
end
