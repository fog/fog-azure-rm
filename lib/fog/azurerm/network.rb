module Fog
  module Network
    # Fog Service Class for AzureRM
    class AzureRM < Fog::Service
      requires :tenant_id
      requires :client_id
      requires :client_secret
      requires :subscription_id
      recognizes :environment

      request_path 'fog/azurerm/requests/network'
      request :create_or_update_virtual_network
      request :get_virtual_network
      request :add_dns_servers_in_virtual_network
      request :remove_dns_servers_from_virtual_network
      request :add_address_prefixes_in_virtual_network
      request :remove_subnets_from_virtual_network
      request :remove_address_prefixes_from_virtual_network
      request :add_subnets_in_virtual_network
      request :delete_virtual_network
      request :list_virtual_networks
      request :list_virtual_networks_in_subscription
      request :check_virtual_network_exists
      request :create_or_update_public_ip
      request :delete_public_ip
      request :get_public_ip
      request :list_public_ips
      request :check_public_ip_exists
      request :create_subnet
      request :attach_network_security_group_to_subnet
      request :detach_network_security_group_from_subnet
      request :attach_route_table_to_subnet
      request :detach_route_table_from_subnet
      request :list_subnets
      request :get_subnet
      request :get_available_ipaddresses_count
      request :delete_subnet
      request :check_subnet_exists
      request :create_or_update_network_interface
      request :delete_network_interface
      request :list_network_interfaces
      request :get_network_interface
      request :check_network_interface_exists
      request :attach_resource_to_nic
      request :detach_resource_from_nic
      request :create_load_balancer
      request :delete_load_balancer
      request :list_load_balancers
      request :get_load_balancer
      request :check_load_balancer_exists
      request :list_load_balancers_in_subscription
      request :create_or_update_network_security_group
      request :delete_network_security_group
      request :list_network_security_groups
      request :get_network_security_group
      request :check_net_sec_group_exists
      request :add_security_rules
      request :remove_security_rule
      request :delete_virtual_network_gateway
      request :create_or_update_virtual_network_gateway
      request :list_virtual_network_gateways
      request :get_virtual_network_gateway
      request :check_vnet_gateway_exists
      request :create_or_update_express_route_circuit
      request :delete_express_route_circuit
      request :get_express_route_circuit
      request :list_express_route_circuits
      request :check_express_route_circuit_exists
      request :create_or_update_express_route_circuit_peering
      request :delete_express_route_circuit_peering
      request :get_express_route_circuit_peering
      request :list_express_route_circuit_peerings
      request :create_or_update_express_route_circuit_authorization
      request :delete_express_route_circuit_authorization
      request :get_express_route_circuit_authorization
      request :list_express_route_circuit_authorizations
      request :check_express_route_cir_auth_exists
      request :list_express_route_service_providers
      request :create_or_update_local_network_gateway
      request :delete_local_network_gateway
      request :get_local_network_gateway
      request :list_local_network_gateways
      request :check_local_net_gateway_exists
      request :create_or_update_virtual_network_gateway_connection
      request :delete_virtual_network_gateway_connection
      request :get_virtual_network_gateway_connection
      request :list_virtual_network_gateway_connections
      request :check_vnet_gateway_connection_exists
      request :get_connection_shared_key
      request :reset_connection_shared_key
      request :set_connection_shared_key
      request :create_or_update_network_security_rule
      request :delete_network_security_rule
      request :get_network_security_rule
      request :list_network_security_rules
      request :check_net_sec_rule_exists

      model_path 'fog/azurerm/models/network'
      model :virtual_network
      collection :virtual_networks
      model :public_ip
      collection :public_ips
      model :subnet
      collection :subnets
      model :network_interface
      collection :network_interfaces
      model :load_balancer
      collection :load_balancers
      model :frontend_ip_configuration
      model :inbound_nat_pool
      model :inbound_nat_rule
      model :load_balancing_rule
      model :probe
      model :network_security_group
      collection :network_security_groups
      model :network_security_rule
      collection :network_security_rules
      model :path_rule
      model :vpn_client_configuration
      model :vpn_client_revoked_certificates
      model :vpn_client_root_certificates
      model :virtual_network_gateway
      collection :virtual_network_gateways
      model :express_route_circuit
      collection :express_route_circuits
      model :express_route_circuit_peering
      collection :express_route_circuit_peerings
      model :express_route_circuit_authorization
      collection :express_route_circuit_authorizations
      model :express_route_service_provider
      collection :express_route_service_providers
      model :local_network_gateway
      collection :local_network_gateways
      model :virtual_network_gateway_connection
      collection :virtual_network_gateway_connections

      # Mock class for Network Service
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

      # Real class for Network Service
      class Real
        def initialize(options)
          begin
            require 'azure_mgmt_network'
            require 'yaml'
          rescue LoadError => e
            retry if require('rubygems')
            raise e.message
          end

          options[:environment] = 'AzureCloud' if options[:environment].nil?

          credentials = Fog::Credentials::AzureRM.get_credentials(options[:tenant_id], options[:client_id], options[:client_secret], options[:environment])
          telemetry = "fog-azure-rm/#{Fog::AzureRM::VERSION}"
          @network_client = ::Azure::Network::Profiles::Latest::Mgmt::Client.new(options)
          @network_client.subscription_id = options[:subscription_id]
          @network_client.add_user_agent_information(telemetry)
          @tenant_id = options[:tenant_id]
          @client_id = options[:client_id]
          @client_secret = options[:client_secret]
          @subscription_id = options[:subscription_id]
          @environment = options[:environment]
          current_directory = File.dirname(__FILE__)
          @logger_messages = YAML.load_file("#{current_directory}/utilities/logger_messages.yml")
        end
      end
    end
  end
end
