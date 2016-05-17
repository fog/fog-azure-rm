module ApiStub
  module Models
    module Compute
      # Mock class for Availability Set Model
      class AvailabilitySet
        def self.create_availability_set_response
          {
              "id" => "/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Compute/availabilitySets/fog-test-availability-set",
              "name" =>  "fog-test-availability-set",
              "type" => "Microsoft.Compute/availabilitySets",
              "location" => "westus",
              "properties" => {
                  "platformUpdateDomainCount" => 5,
                  "platformFaultDomainCount" => 3
              }
          }
        end

        def self.delete_availability_set_response
          MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
        end
      end
    end
  end
end
