module Fog
  module ApplicationGateway
    # Fog Service Class for AzureRM
    class AzureRM < Fog::Service
      requires :tenant_id
      requires :client_id
      requires :client_secret
      requires :subscription_id

      request_path 'fog/azurerm/requests/application_gateway'
      request :create_or_update_application_gateway
      request :delete_application_gateway
      request :list_application_gateways
      request :get_application_gateway
      request :update_subnet_id_in_gateway_ip_configuration
      request :update_sku_attributes

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

          credentials = Fog::Credentials::AzureRM.get_credentials(options[:tenant_id], options[:client_id], options[:client_secret])
          @network_client = ::Azure::ARM::Network::NetworkManagementClient.new(credentials)
          @network_client.subscription_id = options[:subscription_id]
          @tenant_id = options[:tenant_id]
          @client_id = options[:client_id]
          @client_secret = options[:client_secret]
          @subscription_id = options[:subscription_id]
        end
      end
    end
  end
end
