require 'fog/core/collection'
require 'fog/azurerm/models/resources/deployment'

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

        def get(identity)
          all.find { |deployment| deployment.name == identity }
        end
      end
    end
  end
end
