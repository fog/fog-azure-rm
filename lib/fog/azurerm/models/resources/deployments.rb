module Fog
  module Resources
    class AzureRM
      # Deployments collection class
      class Deployments < Fog::Collection
        attribute :resource_group
        model Deployment

        def all
          requires :resource_group
          deployments = []
          service.list_deployments(resource_group).each do |deployment|
            deployments << Deployment.parse(deployment)
          end
          load(deployments)
        end

        def get(resource_group_name, deployment_name)
          deployment = service.get_deployment(resource_group_name, deployment_name)
          deployment_object = Deployment.new(service: service)
          deployment_object.merge_attributes(Deployment.parse(deployment))
        end
      end
    end
  end
end
