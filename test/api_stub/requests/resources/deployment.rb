module ApiStub
  module Requests
    module Resources
      # Mock class for Deployment Requests
      class Deployment
        def self.create_deployment_response(client)
          body = ApiStub::Models::Resources::Deployment.create_deployment_response
          result = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
          result_mapper = Azure::ARM::Resources::Models::DeploymentExtended.mapper
          result.body = client.deserialize(result_mapper, body, 'result.body')
          result
        end

        def self.list_deployment_response(client)
          body = ApiStub::Models::Resources::Deployment.list_deployments_response
          body = { 'value' => body }
          result = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
          result_mapper = Azure::ARM::Resources::Models::DeploymentListResult.mapper
          result.body = client.deserialize(result_mapper, body, 'result.body')
          result
        end
      end
    end
  end
end
