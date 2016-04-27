module ApiStub
  module Models
    module Compute
      # Mock class for Availability Set Model
      class AvailabilitySet
        def self.create_availability_set_response
          MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
        end
      end
    end
  end
end
