module ApiStub
  module Requests
    module Resources
      # Mock class for Deployment Requests
      class Deployment
        def self.create_deployment_response(client)
          body = ApiStub::Models::Resources::Deployment.create_deployment_response
          result_mapper = Azure::ARM::Resources::Models::DeploymentExtended.mapper
          client.deserialize(result_mapper, body, 'result.body')
        end

        def self.list_deployment_response(client)
          body = ApiStub::Models::Resources::Deployment.list_deployments_response
          body = { 'value' => body }
          result_mapper = Azure::ARM::Resources::Models::DeploymentListResult.mapper
          client.deserialize(result_mapper, body, 'result.body')
        end
      end
    end
  end
end
