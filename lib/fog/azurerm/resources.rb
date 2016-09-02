require 'fog/azurerm/core'
require 'fog/azurerm/credentials'

module Fog
  module Resources
    # This class registers models, requests and collections
    class AzureRM < Fog::Service
      requires :tenant_id
      requires :client_id
      requires :client_secret
      requires :subscription_id

      request_path 'fog/azurerm/requests/resources'
      request :create_resource_group
      request :list_resource_groups
      request :delete_resource_group
      request :get_resource_group
      request :create_deployment
      request :delete_deployment
      request :list_deployments
      request :get_deployment
      request :delete_resource_tag
      request :list_tagged_resources
      request :tag_resource

      model_path 'fog/azurerm/models/resources'
      model :resource_group
      collection :resource_groups
      model :deployment
      collection :deployments
      model :dependency
      model :provider
      model :provider_resource_type
      model :azure_resource
      collection :azure_resources

      # This class provides the mock implementation for unit tests.
      class Mock
        def initialize(_options = {})
          begin
            require 'azure_mgmt_resources'
          rescue LoadError => e
            retry if require('rubygems')
            raise e.message
          end
        end
      end

      # This class provides the actual implemention for service calls.
      class Real
        def initialize(options)
          begin
            require 'azure_mgmt_resources'
          rescue LoadError => e
            retry if require('rubygems')
            raise e.message
          end

          credentials = Fog::Credentials::AzureRM.get_credentials(options[:tenant_id], options[:client_id], options[:client_secret])
          @rmc = ::Azure::ARM::Resources::ResourceManagementClient.new(credentials)
          @rmc.subscription_id = options[:subscription_id]
        end
      end
    end
  end
end
