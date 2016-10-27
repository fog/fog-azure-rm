module Fog
  module Resources
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def create_deployment(resource_group, deployment_name, template_link, parameters_link)
          msg = "Creating Deployment: #{deployment_name} in Resource Group: #{resource_group}"
          Fog::Logger.debug msg
          deployment = create_deployment_object(template_link, parameters_link)
          begin
            @rmc.deployments.validate(resource_group, deployment_name, deployment)
            deployment = @rmc.deployments.create_or_update(resource_group, deployment_name, deployment)
          rescue  MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Deployment: #{deployment_name} in Resource Group: #{resource_group} created successfully."
          deployment
        end

        private

        def create_deployment_object(template_link, parameters_link)
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
          deployment
        end
      end

      # This class provides the mock implementation
      class Mock
        def create_deployment(resource_group, deployment_name, template_link, parameters_link)
          deployment = {
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
          result_mapper = Azure::ARM::Resources::Models::DeploymentExtended.mapper
          @rmc.deserialize(result_mapper, deployment, 'result.body')
        end
      end
    end
  end
end
