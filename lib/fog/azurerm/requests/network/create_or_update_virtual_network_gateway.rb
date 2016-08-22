
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
            virtual_network_gateway = @network_client.virtual_network_gateways.create_or_update(virtual_network_params[:resource_group_name], virtual_network_params[:name], network_gateway).value!
            Fog::Logger.debug "Virtual Network Gateway #{virtual_network_params[:name]} created/updated successfully."
            Azure::ARM::Network::Models::VirtualNetworkGateway.serialize_object(virtual_network_gateway.body)
          rescue MsRestAzure::AzureOperationError => e
            raise generate_exception_message(msg, e)
          end
        end

        private

        def get_network_gateway_object(virtual_network_params)
          bgp_settings = Azure::ARM::Network::Models::BgpSettings.new
          bgp_settings.asn = virtual_network_params[:asn]
          bgp_settings.bgp_peering_address = virtual_network_params[:bgp_peering_address]
          bgp_settings.peer_weight = virtual_network_params[:peer_weight]

          default_site = MsRestAzure::SubResource.new
          default_site.id = virtual_network_params[:gateway_default_site]

          sku = Azure::ARM::Network::Models::VirtualNetworkGatewaySku.new
          sku.name = virtual_network_params[:sku_name]
          sku.capacity = virtual_network_params[:sku_capacity]
          sku.tier = virtual_network_params[:sku_tier]

          network_gateway_prop = Azure::ARM::Network::Models::VirtualNetworkGatewayPropertiesFormat.new
          network_gateway_prop.enable_bgp = virtual_network_params[:enable_bgp]
          network_gateway_prop.gateway_type = virtual_network_params[:gateway_type]
          network_gateway_prop.provisioning_state = virtual_network_params[:provisioning_state]
          network_gateway_prop.vpn_type = virtual_network_params[:vpn_type]
          network_gateway_prop.sku = sku
          network_gateway_prop.bgp_settings = bgp_settings
          network_gateway_prop.gateway_default_site = default_site
          if virtual_network_params[:ip_configurations]
            ip_configurations = get_ip_configurations(virtual_network_params[:ip_configurations])
            network_gateway_prop.ip_configurations = ip_configurations
          end

          if virtual_network_params[:vpn_client_configuration]
            vpn_client_config = get_vpn_client_config(virtual_network_params[:vpn_client_configuration])
            network_gateway_prop.vpn_client_configuration = vpn_client_config
          end

          network_gateway = Azure::ARM::Network::Models::VirtualNetworkGateway.new
          network_gateway.name = virtual_network_params[:name]
          network_gateway.location = virtual_network_params[:location]
          network_gateway.tags = virtual_network_params[:tags] if network_gateway.tags.nil?
          network_gateway.properties = network_gateway_prop

          network_gateway
        end

        def get_vpn_client_config(vpn_client_config)
          client_config = Azure::ARM::Network::Models::VpnClientConfiguration.new
          client_config.vpn_client_address_pool = vpn_client_config[:address_pool]

          if vpn_client_config[:root_certificates]
            root_certificates = get_root_certificates(vpn_client_config[:root_certificates])
            client_config.vpn_client_root_certificates = root_certificates
          end

          if vpn_client_config[:revoked_certificates]
            revoked_certificates = get_revoked_certificates(vpn_client_config[:revoked_certificates])
            client_config.vpn_client_revoked_certificates = revoked_certificates
          end
        end

        def get_root_certificates(root_certificates)
          root_certs = []
          root_certificates.each do |root_cert|
            root_certificate = Azure::ARM::Network::Models::VpnClientRootCertificate.new
            root_certificate_prop = Azure::ARM::Network::Models::VpnClientRootCertificatePropertiesFormat.new
            root_certificate_prop.public_cert_data = root_cert[:public_cert_data]
            root_certificate_prop.provisioning_state = root_cert[:provisioning_state]

            root_certificate.name = root_cert[:name]
            root_certificate.properties = root_certificate_prop
            root_certs.push(root_certificate)
          end
          root_certs
        end

        def get_revoked_certificates(revoked_certificates)
          revoked_certs = []
          revoked_certificates.each do |revoked_cert|
            revoked_certificate = Azure::ARM::Network::Models::VpnClientRevokedCertificate.new
            revoked_certificate_prop = Azure::ARM::Network::Models::VpnClientRevokedCertificatePropertiesFormat.new
            revoked_certificate_prop.public_cert_data = revoked_cert[:thumbprint]
            revoked_certificate_prop.provisioning_state = revoked_cert[:provisioning_state]

            revoked_certificate.name = revoked_cert[:name]
            revoked_certificate.properties = revoked_certificate_prop
            revoked_certs.push(revoked_certificate)
          end
          revoked_certs
        end

        def get_ip_configurations(ip_configurations)
          ip_configuration_arr = []
          ip_configurations.each do |ip_config|
            ip_configuration = Azure::ARM::Network::Models::VirtualNetworkGatewayIPConfiguration.new
            ip_configuration_prop = Azure::ARM::Network::Models::VirtualNetworkGatewayIPConfigurationPropertiesFormat.new
            ip_configuration_prop.private_ipaddress = ip_config[:private_ipaddress]
            ip_configuration_prop.private_ipallocation_method = ip_config[:private_ipallocation_method]
            unless ip_config[:subnet_id].nil?
              subnet = Azure::ARM::Network::Models::Subnet.new
              subnet.id = ip_config[:subnet_id]
              ip_configuration_prop.subnet = subnet
            end
            unless ip_config[:public_ipaddress_id].nil?
              pip = Azure::ARM::Network::Models::PublicIPAddress.new
              pip.id = ip_config[:public_ipaddress_id]
              ip_configuration_prop.public_ipaddress = pip
            end

            ip_configuration.name = ip_config[:name]
            ip_configuration.properties = ip_configuration_prop
            ip_configuration_arr.push(ip_configuration)
          end
          ip_configuration_arr
        end
      end

      # Mock class for Network Request
      class Mock
        def create_or_update_virtual_network_gateway(*)
          {
            'name' => 'myvirtualgateway1',
            'location' => 'West US',
            'tags' => { 'key1' => 'value1' },
            'properties' => {
              'gatewayType' => 'DynamicRouting',
              'gatewaySize' => 'Default',
              'bgpEnabled' => true,
              'vpnClientAddressPool' => [ '{vpnClientAddressPoolPrefix}' ],
              'defaultSites' => [ 'mysite1' ]
            }
          }
        end
      end
    end
  end
end
