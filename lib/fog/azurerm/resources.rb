require 'fog/azurerm/core'

module Fog
  module Resources
    class AzureRM < Fog::Service
      requires :tenant_id
      requires :client_id
      requires :client_secret
      requires :subscription_id

      request_path 'fog/azurerm/requests/resources'
      request :create_resource_group
      request :list_resource_groups
      request :delete_resource_group

      model_path 'fog/azurerm/models/resources'
      model :resource_group
      collection :resource_groups

      class Mock
        def initialize(options = {})
          begin
            require 'azure_mgmt_resources'
          rescue LoadError => e
            retry if require('rubygems')
            raise e.message
          end
        end
      end

      class Real
        def initialize(options)
          begin
            require 'azure_mgmt_resources'
          rescue LoadError => e
            retry if require('rubygems')
            raise e.message
          end
          token_provider = MsRestAzure::ApplicationTokenProvider.new(options[:tenant_id], options[:client_id], options[:client_secret])
          credentials = MsRest::TokenCredentials.new(token_provider)
          @rmc = ::Azure::ARM::Resources::ResourceManagementClient.new(credentials)
          @rmc.subscription_id = options[:subscription_id]
        end
      end
    end
  end
end
