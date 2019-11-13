module Fog
  module ApplicationGateway
    # Fog Service Class for AzureRM
    class AzureRM < Fog::Service
      requires :tenant_id
      requires :client_id
      requires :client_secret
      requires :subscription_id
      recognizes :environment

      request_path 'fog/azurerm/requests/application_gateway'
      request :create_or_update_application_gateway
      request :delete_application_gateway
      request :list_application_gateways
      request :get_application_gateway
      request :check_ag_exists
      request :update_subnet_id_in_gateway_ip_configuration
      request :update_sku_attributes
      request :start_application_gateway
      request :stop_application_gateway

      model_path 'fog/azurerm/models/application_gateway'
      model :gateway
      collection :gateways
      model :backend_address_pool
      model :backend_http_setting
      model :frontend_ip_configuration
      model :frontend_port
      model :ip_configuration
      model :http_listener
      model :probe
      model :request_routing_rule
      model :ssl_certificate
      model :url_path_map

      # Mock class for Application Gateway Service
      class Mock
        def initialize(_options = {})
          begin
            require 'azure_mgmt_network'
          rescue LoadError => e
            retry if require('rubygems')
            raise e.message
          end
        end
      end

      # Real class for Application Gateway Service
      class Real
        def initialize(options = {})
          begin
            require 'azure_mgmt_network'
          rescue LoadError => e
            retry if require('rubygems')
            raise e.message
          end

          telemetry = "fog-azure-rm/#{Fog::AzureRM::VERSION}"

          options[:environment] = 'AzureCloud' if options[:environment].nil?

          credentials = Fog::Credentials::AzureRM.get_credentials(options[:tenant_id], options[:client_id], options[:client_secret], options[:environment])
          @network_client = ::Azure::Network::Profiles::Latest::Mgmt::NetworkManagementClient.new(credentials, resource_manager_endpoint_url(options[:environment]))
          @network_client.subscription_id = options[:subscription_id]
          @network_client.add_user_agent_information(telemetry)
          @tenant_id = options[:tenant_id]
          @client_id = options[:client_id]
          @client_secret = options[:client_secret]
          @subscription_id = options[:subscription_id]
          @environment = options[:environment]
        end
      end
    end
  end
end
