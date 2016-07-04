module Fog
  module Resources
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def create_deployment(resource_group, deployment_name, template_link, parameters_link)
          begin
            Fog::Logger.debug "Creating Deployment: #{deployment_name} in Resource Group: #{resource_group}"
            deployment = Azure::ARM::Resources::Models::Deployment.new
            deployment_properties = Azure::ARM::Resources::Models::DeploymentProperties.new

            template_link_obj = Azure::ARM::Resources::Models::TemplateLink.new
            template_link_obj.uri = template_link

            parameters_link_obj = Azure::ARM::Resources::Models::ParametersLink.new
            parameters_link_obj.uri = parameters_link

            deployment_properties.template_link = template_link_obj
            deployment_properties.parameters_link = parameters_link_obj
            deployment_properties.mode = 'Incremental'

            deployment.properties = deployment_properties

            @rmc.deployments.validate(resource_group, deployment_name, deployment)
            promise = @rmc.deployments.create_or_update(resource_group, deployment_name, deployment)
            result = promise.value!
            Fog::Logger.debug "Deployment: #{deployment_name} in Resource Group: #{resource_group} created successfully."
            Azure::ARM::Resources::Models::DeploymentExtended.serialize_object(result.body)
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Exception creating Deployment: #{deployment_name} in Resource Group: #{resource_group}. #{e.body['error']['message']}"
            raise msg
          end
        end
      end

      # This class provides the mock implementation
      class Mock
        def create_deployment(resource_group, deployment_name, template_link, parameters_link)
          {
            id: "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/microsoft.resources/deployments/#{deployment_name}",
            name: deployment_name,
            properties: {
              templateLink: {
                uri: template_link,
                contentVersion: '1.0.0.0'
              },
              parametersLink: {
                uri: parameters_link,
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
          }
        end
      end
    end
  end
end
