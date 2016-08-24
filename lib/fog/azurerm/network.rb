require 'fog/azurerm/core'

module Fog
  module Network
    # Fog Service Class for AzureRM
    class AzureRM < Fog::Service
      requires :tenant_id
      requires :client_id
      requires :client_secret
      requires :subscription_id

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
      request :check_for_virtual_network
      request :create_public_ip
      request :delete_public_ip
      request :list_public_ips
      request :check_for_public_ip
      request :create_subnet
      request :attach_network_security_group_to_subnet
      request :detach_network_security_group_from_subnet
      request :attach_route_table_to_subnet
      request :detach_route_table_from_subnet
      request :list_subnets
      request :get_subnet
      request :delete_subnet
      request :create_or_update_network_interface
      request :delete_network_interface
      request :list_network_interfaces
      request :get_network_interface
      request :attach_resource_to_nic
      request :detach_resource_from_nic
      request :create_load_balancer
      request :delete_load_balancer
      request :list_load_balancers
      request :create_or_update_network_security_group
      request :delete_network_security_group
      request :list_network_security_groups
      request :get_network_security_group
      request :add_security_rules
      request :remove_security_rule
      request :create_traffic_manager_profile
      request :get_traffic_manager_profile
      request :delete_traffic_manager_profile
      request :list_traffic_manager_profiles
      request :create_traffic_manager_endpoint
      request :delete_traffic_manager_endpoint
      request :delete_virtual_network_gateway
      request :create_or_update_virtual_network_gateway
      request :list_virtual_network_gateways
      request :get_virtual_network_gateway

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
      model :path_rule
      model :vpn_client_configuration
      model :vpn_client_revoked_certificates
      model :vpn_client_root_certificates
      model :traffic_manager_profile
      collection :traffic_manager_profiles
      model :traffic_manager_end_point
      collection :traffic_manager_end_points
      model :virtual_network_gateway
      collection :virtual_network_gateways

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
