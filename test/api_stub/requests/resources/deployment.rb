module ApiStub
  module Requests
    module Resources
      # Mock class for Deployment Requests
      class Deployment
        def self.create_deployment_response(client)
          ApiStub::Models::Resources::Deployment.create_deployment_response(client)
        end

        def self.list_deployment_response(client)
          deployments = {
            'value' => [
              {
                'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/microsoft.resources/deployments/fog-test-deployment',
                'name' => 'fog-test-deployment',
                'properties' => {
                  'templateLink' => {
                    'uri' => 'https://test.com/template.json',
                    'contentVersion' => '1.0.0.0'
                  },
                  'parametersLink' => {
                    'uri' => 'https://test.com/parameters.json',
                    'contentVersion' => '1.0.0.0'
                  },
                  'parameters' => {
                    'parameter1' => {
                      'type' => 'string',
                      'value' => 'parameter1'
                    }
                  },
                  'mode' => 'Incremental',
                  'provisioningState' => 'Accepted',
                  'timestamp' => '2015-01-01T18:26:20.6229141Z',
                  'correlationId' => 'd5062e45-6e9f-4fd3-a0a0-6b2c56b15757',
                  'outputs' => {
                    'key1' => {
                      'type' => 'string',
                      'value' => 'output1'
                    }
                  },
                  'providers' => [{
                    'namespace' => 'namespace1',
                    'resourceTypes' => [{
                      'resourceType' => 'resourceType1',
                      'locations' => ['westus']
                    }]
                  }],
                  'dependencies' => [{
                    'dependsOn' => [{
                      'id' => 'resourceid1',
                      'resourceType' => 'namespace1/resourcetype1',
                      'resourceName' => 'resourcename1'
                    }],
                    'id' => 'resourceid2',
                    'resourceType' => 'namespace1/resourcetype2',
                    'resourceName' => 'resourcename2'
                  }]
                }
              }
            ]
          }
          result_mapper = Azure::ARM::Resources::Models::DeploymentListResult.mapper
          client.deserialize(result_mapper, deployments, 'result.body')
        end
      end
    end
  end
end
