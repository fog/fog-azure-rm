module ApiStub
  module Models
    module Compute
      class AvailabilitySet
        def self.create_availability_set_response
          MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
        end
      end
    end
  end
end
