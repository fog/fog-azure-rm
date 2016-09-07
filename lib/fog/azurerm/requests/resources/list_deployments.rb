module Fog
  module Resources
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def list_deployments(resource_group)
          msg = "Listing Deployments in Resource Group: #{resource_group}"
          Fog::Logger.debug msg
          begin
            deployments = @rmc.deployments.list_as_lazy(resource_group)
          rescue  MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Deployments listed successfully in Resource Group: #{resource_group}"
          deployments.value
        end
      end

      # This class provides the mock implementation
      class Mock
        def list_deployments(resource_group)
          deployments = {
            value: [{
              id: "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/microsoft.resources/deployments/testdeployment",
              name: 'testdeployment',
              properties: {
                templateLink: {
                  uri: 'https://test.com/template.json',
                  contentVersion: '1.0.0.0'
                },
                parametersLink: {
                  uri: 'https://test.com/parameters.json',
                  contentVersion: '1.0.0.0'
                },
                parameters: {
                  parameter1: {
                    type: 'string',
                    value: 'parameter1'
                  }
                },
                mode: 'Incremental',
                provisioningState: 'Accepted',
                timestamp: '2015-01-01T18:26:20.6229141Z',
                correlationId: 'd5062e45-6e9f-4fd3-a0a0-6b2c56b15757',
                outputs: {
                  key1: {
                    type: 'string',
                    value: 'output1'
                  }
                },
                providers: [{
                  namespace: 'namespace1',
                  resourceTypes: [{
                    resourceType: 'resourceType1',
                    locations: ['westus']
                  }]
                }],
                dependencies: [{
                  dependsOn: [{
                    id: 'resourceid1',
                    resourceType: 'namespace1/resourcetype1',
                    resourceName: 'resourcename1'
                  }],
                  id: 'resourceid2',
                  resourceType: 'namespace1/resourcetype2',
                  resourceName: 'resourcename2'
                }]
              }
            }]
          }
          result_mapper = Azure::ARM::Resources::Models::DeploymentListResult.mapper
          @rmc.deserialize(result_mapper, deployments, 'result.body').value
        end
      end
    end
  end
end
