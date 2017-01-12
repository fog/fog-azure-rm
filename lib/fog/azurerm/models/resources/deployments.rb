module Fog
  module Resources
    class AzureRM
      # Deployments collection class
      class Deployments < Fog::Collection
        attribute :resource_group
        model Fog::Resources::AzureRM::Deployment

        def all
          requires :resource_group
          deployments = []
          service.list_deployments(resource_group).each do |deployment|
            deployments << Fog::Resources::AzureRM::Deployment.parse(deployment)
          end
          load(deployments)
        end

        def get(resource_group_name, deployment_name)
          deployment = service.get_deployment(resource_group_name, deployment_name)
          deployment_fog = Fog::Resources::AzureRM::Deployment.new(service: service)
          deployment_fog.merge_attributes(Fog::Resources::AzureRM::Deployment.parse(deployment))
        end

        def check_deployment_exists(resource_group_name, deployment_name)
          service.check_deployment_exists(resource_group_name, deployment_name)
        end
      end
    end
  end
end
