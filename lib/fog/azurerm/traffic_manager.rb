module Fog
  module TrafficManager
    # This class registers models, requests and collections
    class AzureRM < Fog::Service
      requires :tenant_id
      requires :client_id
      requires :client_secret
      requires :subscription_id
      recognizes :environment

      request_path 'fog/azurerm/requests/traffic_manager'
      request :create_or_update_traffic_manager_profile
      request :delete_traffic_manager_profile
      request :get_traffic_manager_profile
      request :list_traffic_manager_profiles

      request :create_or_update_traffic_manager_endpoint
      request :delete_traffic_manager_endpoint
      request :get_traffic_manager_endpoint

      model_path 'fog/azurerm/models/traffic_manager'
      model :traffic_manager_profile
      collection :traffic_manager_profiles

      model :traffic_manager_end_point
      collection :traffic_manager_end_points

      # This class provides the actual implementation for service calls.
      class Real
        def initialize(options)
          begin
            require 'azure_mgmt_traffic_manager'
          rescue LoadError => e
            retry if require('rubygems')
            raise e.message
          end

          options[:environment] = 'AzureCloud' if options[:environment].nil?

          credentials = Fog::Credentials::AzureRM.get_credentials(options[:tenant_id], options[:client_id], options[:client_secret], options[:environment])
          telemetry = "fog-azure-rm/#{Fog::AzureRM::VERSION}"
          @traffic_mgmt_client = ::Azure::ARM::TrafficManager::TrafficManagerManagementClient.new(credentials, resource_manager_endpoint_url(options[:environment]))
          @traffic_mgmt_client.subscription_id = options[:subscription_id]
          @traffic_mgmt_client.add_user_agent_information(telemetry)
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def initialize(_options = {})
          begin
            require 'azure_mgmt_traffic_manager'
          rescue LoadError => e
            retry if require('rubygems')
            raise e.message
          end
        end
      end
    end
  end
end
