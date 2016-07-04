module ApiStub
  module Requests
    module Resources
      # Mock class for Deployment Requests
      class Deployment
        def self.create_deployment_response
          body = ApiStub::Models::Resources::Deployment.create_deployment_response
          result = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
          result.body = Azure::ARM::Resources::Models::DeploymentExtended.deserialize_object(body)
          result
        end

        def self.list_deployment_response
          body = ApiStub::Models::Resources::Deployment.list_deployments_response
          body = { 'value' => body }
          result = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
          result.body = Azure::ARM::Resources::Models::DeploymentListResult.deserialize_object(body)
          result
        end
      end
    end
  end
end
