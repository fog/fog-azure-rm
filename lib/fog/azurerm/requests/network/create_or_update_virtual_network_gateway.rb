
module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def create_or_update_virtual_network_gateway(virtual_network_params)
          msg = "Creating/Updating Virtual Network Gateway: #{virtual_network_params[:name]} in Resource Group: #{virtual_network_params[:resource_group_name]}."
          Fog::Logger.debug msg
          network_gateway = get_network_gateway_object(virtual_network_params)
          begin
            virtual_network_gateway = @network_client.virtual_network_gateways.create_or_update(virtual_network_params[:resource_group_name], virtual_network_params[:name], network_gateway)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Virtual Network Gateway #{virtual_network_params[:name]} created/updated successfully."
          virtual_network_gateway
        end

        private

        def get_network_gateway_object(virtual_network_params)
          network_gateway = Azure::Network::Profiles::Latest::Mgmt::Models::VirtualNetworkGateway.new

          network_gateway.enable_bgp = virtual_network_params[:enable_bgp]
          network_gateway.gateway_type = virtual_network_params[:gateway_type]
          network_gateway.provisioning_state = virtual_network_params[:provisioning_state]
          network_gateway.vpn_type = virtual_network_params[:vpn_type]
          network_gateway.sku = get_virtual_network_gateway_sku(virtual_network_params)
          if virtual_network_params[:gateway_default_site]
            default_site = MsRestAzure::SubResource.new
            default_site.id = virtual_network_params[:gateway_default_site]
            network_gateway.gateway_default_site = default_site
          end
          if virtual_network_params[:ip_configurations]
            ip_configurations = get_ip_configurations(virtual_network_params[:ip_configurations])
            network_gateway.ip_configurations = ip_configurations
          end

          if virtual_network_params[:enable_bgp]
            network_gateway.bgp_settings = get_bgp_settings(virtual_network_params)
          end

          if virtual_network_params[:vpn_client_configuration]
            vpn_client_config = get_vpn_client_config(virtual_network_params[:vpn_client_configuration])
            network_gateway.vpn_client_configuration = vpn_client_config
          end

          network_gateway.name = virtual_network_params[:name]
          network_gateway.location = virtual_network_params[:location]
          network_gateway.tags = virtual_network_params[:tags] if network_gateway.tags.nil?

          network_gateway
        end

        def get_bgp_settings(virtual_network_params)
          bgp_settings = Azure::Network::Profiles::Latest::Mgmt::Models::BgpSettings.new
          bgp_settings.asn = virtual_network_params[:asn]
          bgp_settings.bgp_peering_address = virtual_network_params[:bgp_peering_address]
          bgp_settings.peer_weight = virtual_network_params[:peer_weight]
          bgp_settings
        end

        def get_virtual_network_gateway_sku(virtual_network_params)
          sku = Azure::Network::Profiles::Latest::Mgmt::Models::VirtualNetworkGatewaySku.new
          sku.name = virtual_network_params[:sku_name]
          sku.capacity = virtual_network_params[:sku_capacity]
          sku.tier = virtual_network_params[:sku_tier]
          sku
        end

        def get_vpn_client_config(vpn_client_config)
          client_config = Azure::Network::Profiles::Latest::Mgmt::Models::VpnClientConfiguration.new

          address_pool = Azure::Network::Profiles::Latest::Mgmt::Models::AddressSpace.new
          address_pool.address_prefixes = vpn_client_config[:address_pool]
          client_config.vpn_client_address_pool = address_pool

          if vpn_client_config[:root_certificates]
            root_certificates = get_root_certificates(vpn_client_config[:root_certificates])
            client_config.vpn_client_root_certificates = root_certificates
          end

          if vpn_client_config[:revoked_certificates]
            revoked_certificates = get_revoked_certificates(vpn_client_config[:revoked_certificates])
            client_config.vpn_client_revoked_certificates = revoked_certificates
          end
          client_config
        end

        def get_root_certificates(root_certificates)
          root_certs = []
          root_certificates.each do |root_cert|
            root_certificate = Azure::Network::Profiles::Latest::Mgmt::Models::VpnClientRootCertificate.new
            root_certificate.public_cert_data = root_cert[:public_cert_data]
            root_certificate.provisioning_state = root_cert[:provisioning_state]
            root_certificate.name = root_cert[:name]
            root_certs.push(root_certificate)
          end
          root_certs
        end

        def get_revoked_certificates(revoked_certificates)
          revoked_certs = []
          revoked_certificates.each do |revoked_cert|
            revoked_certificate = Azure::Network::Profiles::Latest::Mgmt::Models::VpnClientRevokedCertificate.new
            revoked_certificate.thumbprint = revoked_cert[:thumbprint]
            revoked_certificate.provisioning_state = revoked_cert[:provisioning_state]
            revoked_certificate.name = revoked_cert[:name]
            revoked_certs.push(revoked_certificate)
          end
          revoked_certs
        end

        def get_ip_configurations(ip_configurations)
          ip_configs = []
          ip_configurations.each do |ip_config|
            ip_configuration = Azure::Network::Profiles::Latest::Mgmt::Models::VirtualNetworkGatewayIPConfiguration.new
            ip_configuration.private_ipallocation_method = ip_config[:private_ipallocation_method]
            unless ip_config[:subnet_id].nil?
              subnet = Azure::Network::Profiles::Latest::Mgmt::Models::Subnet.new
              subnet.id = ip_config[:subnet_id]
              ip_configuration.subnet = subnet
            end
            unless ip_config[:public_ipaddress_id].nil?
              pip = Azure::Network::Profiles::Latest::Mgmt::Models::PublicIPAddress.new
              pip.id = ip_config[:public_ipaddress_id]
              ip_configuration.public_ipaddress = pip
            end

            ip_configuration.name = ip_config[:name]
            ip_configs.push(ip_configuration)
          end
          ip_configs
        end
      end

      # Mock class for Network Request
      class Mock
        def create_or_update_virtual_network_gateway(*)
          gateway = {
            'name' => 'myvirtualgateway1',
            'location' => 'West US',
            'tags' => { 'key1' => 'value1' },
            'properties' => {
              'gatewayType' => 'DynamicRouting',
              'gatewaySize' => 'Default',
              'bgpEnabled' => true,
              'vpnClientAddressPool' => ['{vpnClientAddressPoolPrefix}'],
              'defaultSites' => ['mysite1']
            }
          }
          gateway_mapper = Azure::Network::Profiles::Latest::Mgmt::Models::VirtualNetworkGateway.mapper
          @network_client.deserialize(gateway_mapper, gateway, 'result.body')
        end
      end
    end
  end
end
