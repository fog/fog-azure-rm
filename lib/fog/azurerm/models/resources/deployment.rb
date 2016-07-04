module Fog
  module Resources
    class AzureRM
      # This class is giving implementation of create/save and
      # delete/destroy for Deployment model.
      class Deployment < Fog::Model
        identity :name
        attribute :id
        attribute :resource_group
        attribute :correlation_id
        attribute :timestamp
        attribute :outputs
        attribute :providers
        attribute :dependencies
        attribute :template_link
        attribute :parameters_link
        attribute :mode
        attribute :debug_setting
        attribute :content_version
        attribute :provisioning_state

        def self.parse(deployment)
          hash = {}
          hash['name'] = deployment['name']
          hash['id'] = deployment['id']
          hash['resource_group'] = deployment['id'].split('/')[4]
          hash['correlation_id'] = deployment['correlationId']
          hash['timestamp'] = deployment['timestamp']
          hash['outputs'] = deployment['outputs']

          hash['providers'] = []
          deployment['properties']['providers'].each do |provider|
            provider_obj = Fog::Resources::AzureRM::Provider.new
            hash['providers'] << provider_obj.merge_attributes(Fog::Resources::AzureRM::Provider.parse(provider))
          end

          hash['dependencies'] = []
          deployment['properties']['dependencies'].each do |dependency|
            dependency_obj = Fog::Resources::AzureRM::Dependency.new
            hash['dependencies'] << dependency_obj.merge_attributes(Fog::Resources::AzureRM::Dependency.parse(dependency))
          end

          hash['template_link'] = deployment['properties']['templateLink']['uri']
          hash['parameters_link'] = deployment['properties']['parametersLink']['uri']
          hash['content_version'] = deployment['properties']['templateLink']['contentVersion']
          hash['mode'] = deployment['properties']['mode']
          hash['debug_setting'] = deployment['properties']['debugSetting']['detailLevel'] unless deployment['properties']['debugSetting'].nil?
          hash['provisioning_state'] = deployment['properties']['provisioningState']
          hash
        end

        def save
          requires :name, :resource_group, :template_link, :parameters_link

          deployment = service.create_deployment(resource_group, name, template_link, parameters_link)
          merge_attributes(Fog::Resources::AzureRM::Deployment.parse(deployment))
        end

        def destroy
          service.delete_deployment(resource_group, name)
        end
      end
    end
  end
end
