module Fog
  module ApplicationGateway
    class AzureRM
      # Real class for Application Gateway Request
      class Real
        def create_or_update_application_gateway(gateway_params)
          msg = "Creating/Updated Application Gateway: #{gateway_params[:name]} in Resource Group: #{gateway_params[:resource_group]}."
          Fog::Logger.debug msg
          gateway = define_application_gateway(gateway_params)
          begin
            gateway_obj = @network_client.application_gateways.create_or_update(gateway_params[:resource_group], gateway_params[:name], gateway)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Application Gateway #{gateway_params[:name]} created/updated successfully."
          gateway_obj
        end

        private

        def define_application_gateway(gateway_params)
          application_gateway = Azure::Network::Profiles::Latest::Mgmt::Models::ApplicationGateway.new
          application_gateway.name = gateway_params[:name]
          application_gateway.location = gateway_params[:location]

          application_gateway.gateway_ipconfigurations = define_gateway_ip_configuration(gateway_params[:gateway_ip_configurations]) if gateway_params[:gateway_ip_configurations]
          application_gateway.ssl_certificates = define_ssl_certificate(gateway_params[:ssl_certificates]) if gateway_params[:ssl_certificates]
          application_gateway.frontend_ipconfigurations = define_frontend_ip_configurations(gateway_params[:frontend_ip_configurations]) if gateway_params[:frontend_ip_configurations]
          application_gateway.frontend_ports = define_frontend_ports(gateway_params[:frontend_ports]) if gateway_params[:frontend_ports]
          application_gateway.probes = define_probes(gateway_params[:probes]) if gateway_params[:probes]
          application_gateway.backend_address_pools = define_backend_address_pools(gateway_params[:backend_address_pools]) if gateway_params[:backend_address_pools]
          application_gateway.backend_http_settings_collection = define_backend_http_settings(gateway_params[:backend_http_settings_list]) if gateway_params[:backend_http_settings_list]
          application_gateway.http_listeners = define_http_listeners(gateway_params[:http_listeners]) if gateway_params[:http_listeners]
          application_gateway.url_path_maps = define_url_path_maps(gateway_params[:url_path_maps]) if gateway_params[:url_path_maps]
          application_gateway.request_routing_rules = define_request_routing_rules(gateway_params[:request_routing_rules]) if gateway_params[:request_routing_rules]
          application_gateway.tags = gateway_params[:tags]

          gateway_sku = Azure::Network::Profiles::Latest::Mgmt::Models::ApplicationGatewaySku.new
          gateway_sku.name = gateway_params[:sku_name]
          gateway_sku.tier = gateway_params[:sku_tier]
          gateway_sku.capacity = gateway_params[:sku_capacity]
          application_gateway.sku = gateway_sku

          application_gateway
        end

        def define_gateway_ip_configuration(gateway_ip_configurations)
          gateway_ip_configuration_arr = []
          gateway_ip_configurations.each do |ip_configuration|
            configuration = Azure::Network::Profiles::Latest::Mgmt::Models::ApplicationGatewayIPConfiguration.new
            configuration.provisioning_state = ip_configuration[:provisioning_state]
            if ip_configuration[:subnet_id]
              subnet = Azure::Network::Profiles::Latest::Mgmt::Models::Subnet.new
              subnet.id = ip_configuration[:subnet_id]
              configuration.subnet = subnet
            end

            configuration.name = ip_configuration[:name]
            gateway_ip_configuration_arr.push(configuration)
          end
          gateway_ip_configuration_arr
        end

        def define_ssl_certificate(ssl_certificates)
          ssl_certificate_arr = []
          ssl_certificates.each do |ssl_certificate|
            certificate = Azure::Network::Profiles::Latest::Mgmt::Models::ApplicationGatewaySslCertificate.new
            certificate.data = ssl_certificate[:data]
            certificate.password = ssl_certificate[:password]
            certificate.public_cert_data = ssl_certificate[:public_cert_data]

            certificate.name = ssl_certificate[:name]
            ssl_certificate_arr.push(ssl_certificate)
          end
          ssl_certificate_arr
        end

        def define_frontend_ip_configurations(frontend_ip_configurations)
          frontend_ip_configuration_arr = []
          frontend_ip_configurations.each do |fic|
            frontend_ip_configuration = Azure::Network::Profiles::Latest::Mgmt::Models::ApplicationGatewayFrontendIPConfiguration.new

            frontend_ip_configuration.private_ipaddress = fic[:private_ip_address]
            frontend_ip_configuration.private_ipallocation_method = fic[:private_ip_allocation_method]

            if fic[:subnet_id]
              subnet = Azure::Network::Profiles::Latest::Mgmt::Models::Subnet.new
              subnet.id = fic[:subnet_id]
              frontend_ip_configuration.subnet = subnet
            end

            unless fic[:public_ip_address_id].nil?
              pip = Azure::Network::Profiles::Latest::Mgmt::Models::PublicIPAddress.new
              pip.id = fic[:public_ip_address_id]
              frontend_ip_configuration.public_ipaddress = pip
            end

            frontend_ip_configuration.name = fic[:name]

            frontend_ip_configuration_arr.push(frontend_ip_configuration)
          end
          frontend_ip_configuration_arr
        end

        def define_frontend_ports(frontend_ports)
          frontend_port_arr = []
          frontend_ports.each do |port|
            frontend_port = Azure::Network::Profiles::Latest::Mgmt::Models::ApplicationGatewayFrontendPort.new

            frontend_port.port = port[:port]
            frontend_port.name = port[:name]

            frontend_port_arr.push(frontend_port)
          end
          frontend_port_arr
        end

        def define_probes(probes)
          probe_arr = []
          probes.each do |probe|
            ag_probe = Azure::Network::Profiles::Latest::Mgmt::Models::ApplicationGatewayProbe.new
            ag_probe.protocol = probe[:protocol]
            ag_probe.host = probe[:host]
            ag_probe.path = probe[:path]
            ag_probe.interval = probe[:interval]
            ag_probe.timeout = probe[:timeout]
            ag_probe.unhealthy_threshold = probe[:unhealthy_threshold]

            ag_probe.name = probe[:name]
            probe_arr.push(ag_probe)
          end
          probe_arr
        end

        def define_backend_address_pools(backend_address_pools)
          backend_address_pool_arr = []

          backend_address_pools.each do |bap|
            backend_pool = Azure::Network::Profiles::Latest::Mgmt::Models::ApplicationGatewayBackendAddressPool.new

            backend_addresses1 = bap[:ip_addresses]
            addresses = []
            backend_addresses1.each do |address|
              backend_add = Azure::Network::Profiles::Latest::Mgmt::Models::ApplicationGatewayBackendAddress.new
              backend_add.ip_address = address[:ipAddress]
              addresses.push(backend_add)
            end
            backend_pool.backend_addresses = addresses

            backend_pool.name = bap[:name]
            backend_address_pool_arr.push(backend_pool)
          end
          backend_address_pool_arr
        end

        def define_backend_http_settings(backend_http_settings_list)
          backend_http_setting_arr = []

          backend_http_settings_list.each do |http_setting|
            backend_http_setting = Azure::Network::Profiles::Latest::Mgmt::Models::ApplicationGatewayBackendHttpSettings.new
            backend_http_setting.port = http_setting[:port]
            backend_http_setting.protocol = http_setting[:protocol]
            backend_http_setting.cookie_based_affinity = http_setting[:cookie_based_affinity]
            backend_http_setting.request_timeout = http_setting[:request_timeout]
            if http_setting[:probe]
              probe = Azure::Network::Profiles::Latest::Mgmt::Models::Probe.new
              probe.id = http_setting[:probe]
              backend_http_setting.probe = probe
            end

            backend_http_setting.name = http_setting[:name]
            backend_http_setting_arr.push(backend_http_setting)
          end
          backend_http_setting_arr
        end

        def define_http_listeners(http_listeners)
          http_listener_arr = []

          http_listeners.each do |listener|
            http_listener = Azure::Network::Profiles::Latest::Mgmt::Models::ApplicationGatewayHttpListener.new

            http_listener.protocol = listener[:protocol]
            http_listener.host_name = listener[:host_name]
            http_listener.require_server_name_indication = listener[:require_server_name_indication]
            if listener[:frontend_ip_config_id]
              frontend_ip = Azure::Network::Profiles::Latest::Mgmt::Models::FrontendIPConfiguration.new
              frontend_ip.id = listener[:frontend_ip_config_id]
              http_listener.frontend_ipconfiguration = frontend_ip
            end
            if listener[:frontend_port_id]
              frontend_port = Azure::Network::Profiles::Latest::Mgmt::Models::ApplicationGatewayFrontendPort.new
              frontend_port.id = listener[:frontend_port_id]
              http_listener.frontend_port = frontend_port
            end
            if listener[:ssl_certificate_id]
              ssl_cert = Azure::Network::Profiles::Latest::Mgmt::Models::ApplicationGatewaySslCertificate.new
              ssl_cert.id = listener[:ssl_certificate_id]
              http_listener.ssl_certificate = ssl_cert
            end

            http_listener.name = listener[:name]
            http_listener_arr.push(http_listener)
          end
          http_listener_arr
        end

        def define_url_path_maps(url_path_maps)
          url_path_map_arr = []

          url_path_maps.each do |map|
            url_path_map = Azure::Network::Profiles::Latest::Mgmt::Models::ApplicationGatewayUrlPathMap.new

            if map[:default_backend_address_pool_id]
              default_backend_address_pool = Azure::Network::Profiles::Latest::Mgmt::Models::BackendAddressPool.new
              default_backend_address_pool.id = map[:default_backend_address_pool_id]
              url_path_map.default_backend_address_pool = default_backend_address_pool
            end
            if map[:default_backend_http_settings_id]
              default_backend_http_setting = Azure::Network::Profiles::Latest::Mgmt::Models::ApplicationGatewayBackendHttpSettings.new
              default_backend_http_setting.id = map[:default_backend_http_settings_id]
              url_path_map.default_backend_http_settings = default_backend_http_setting
            end

            if map[:path_rules]
              path_rules = map[:path_rules]
              path_rule_arr = define_path_rules(path_rules)
              url_path_map.path_rules = path_rule_arr
            end

            url_path_map.name = map[:name]
            url_path_map_arr.push(url_path_map)
          end
          url_path_map_arr
        end

        def define_path_rules(path_rules)
          path_rule_arr = []
          path_rules.each do |rule|
            path_rule = Azure::Network::Profiles::Latest::Mgmt::Models::ApplicationGatewayPathRule.new
            if rule[:backend_address_pool_id]
              backend_address_pool = Azure::Network::Profiles::Latest::Mgmt::Models::BackendAddressPool.new
              backend_address_pool.id = rule[:backend_address_pool_id]
              path_rule.backend_address_pool = backend_address_pool
            end
            if rule[:backend_http_settings_id]
              backend_http_setting = Azure::Network::Profiles::Latest::Mgmt::Models::ApplicationGatewayBackendHttpSettings.new
              backend_http_setting.id = rule[:backend_http_settings_id]
              path_rule.backend_http_settings = backend_http_setting
            end
            path_urls = rule[:paths]

            paths = []
            path_urls.each do |url|
              paths.push(url)
            end
            path_rule.paths = paths

            path_rule.name = rule[:name]
            path_rule_arr.push(path_rule)
          end
          path_rule_arr
        end

        def define_request_routing_rules(request_routing_rules)
          request_routing_rule_arr = []

          request_routing_rules.each do |rule|
            request_routing_rule = Azure::Network::Profiles::Latest::Mgmt::Models::ApplicationGatewayRequestRoutingRule.new

            request_routing_rule.rule_type = rule[:type]
            if rule[:http_listener_id]
              http_listener = Azure::Network::Profiles::Latest::Mgmt::Models::ApplicationGatewayHttpListener.new
              http_listener.id = rule[:http_listener_id]
              request_routing_rule.http_listener = http_listener
            end
            if rule[:backend_address_pool_id]
              backend_address_pool = Azure::Network::Profiles::Latest::Mgmt::Models::BackendAddressPool.new
              backend_address_pool.id = rule[:backend_address_pool_id]
              request_routing_rule.backend_address_pool = backend_address_pool
            end
            if rule[:backend_http_settings_id]
              backend_http_setting = Azure::Network::Profiles::Latest::Mgmt::Models::ApplicationGatewayBackendHttpSettings.new
              backend_http_setting.id = rule[:backend_http_settings_id]
              request_routing_rule.backend_http_settings = backend_http_setting
            end

            request_routing_rule.name = rule[:name]
            request_routing_rule_arr.push(request_routing_rule)
          end
          request_routing_rule_arr
        end
      end

      # Mock class for Network Request
      class Mock
        def create_or_update_application_gateway(*)
        end
      end
    end
  end
end
