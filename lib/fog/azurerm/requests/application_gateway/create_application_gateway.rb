module Fog
  module ApplicationGateway
    class AzureRM
      # Real class for Application Gateway Request
      class Real
        def create_application_gateway(name, location, resource_group, sku_name, sku_tier, sku_capacity, gateway_ip_configurations, ssl_certificates, frontend_ip_configurations, frontend_ports, probes, backend_address_pools, backend_http_settings_list, http_listeners, url_path_maps, request_routing_rules)
          Fog::Logger.debug "Creating Application Gateway: #{name} in Resource Group: #{resource_group}."
          gateway = define_application_gateway(name, location, sku_name, sku_tier, sku_capacity, gateway_ip_configurations, ssl_certificates, frontend_ip_configurations, frontend_ports, probes, backend_address_pools, backend_http_settings_list, http_listeners, url_path_maps, request_routing_rules)
          begin
            promise = @network_client.application_gateways.create_or_update(resource_group, name, gateway)
            result = promise.value!
            Fog::Logger.debug "Application Gateway #{name} created successfully."
            Azure::ARM::Network::Models::ApplicationGateway.serialize_object(result.body)
          rescue MsRestAzure::AzureOperationError => e
            raise Fog::AzureRM::OperationError.new(e)
          end
        end

        private

        def define_application_gateway(name, location, sku_name, sku_tier, sku_capacity, gateway_ip_configurations, ssl_certificates, frontend_ip_configurations, frontend_ports, probes, backend_address_pools, backend_http_settings_list, http_listeners, url_path_maps, request_routing_rules)
          ag_props = Azure::ARM::Network::Models::ApplicationGatewayPropertiesFormat.new

          if gateway_ip_configurations
            gateway_ip_configuration_arr = define_gateway_ip_configuration(gateway_ip_configurations)
            ag_props.gateway_ipconfigurations = []
            ag_props.gateway_ipconfigurations = gateway_ip_configuration_arr
          end

          if ssl_certificates
            ssl_certificate_arr = define_ssl_certificate(ssl_certificates)
            ag_props.ssl_certificates = []
            ag_props.ssl_certificates = ssl_certificate_arr
          end

          if frontend_ip_configurations
            frontend_ip_configuration_arr = define_frontend_ip_configurations(frontend_ip_configurations)
            ag_props.frontend_ipconfigurations = []
            ag_props.frontend_ipconfigurations = frontend_ip_configuration_arr
          end

          if frontend_ports
            frontend_port_arr = define_frontend_ports(frontend_ports)
            ag_props.frontend_ports = []
            ag_props.frontend_ports = frontend_port_arr
          end

          if probes
            probe_arr = define_probes(probes)
            ag_props.probes = []
            ag_props.probes = probe_arr
          end

          if backend_address_pools
            backend_address_pool_arr = define_backend_address_pools(backend_address_pools)
            ag_props.backend_address_pools = []
            ag_props.backend_address_pools = backend_address_pool_arr
          end

          if backend_http_settings_list
            backend_http_setting_arr = define_backend_http_settings(backend_http_settings_list)
            ag_props.backend_http_settings_collection = []
            ag_props.backend_http_settings_collection = backend_http_setting_arr
          end

          if http_listeners
            http_listener_arr = define_http_listeners(http_listeners)
            ag_props.http_listeners = []
            ag_props.http_listeners = http_listener_arr
          end

          if url_path_maps
            url_path_maps_arr = define_url_path_maps(url_path_maps)
            ag_props.url_path_maps = []
            ag_props.url_path_maps = url_path_maps_arr
          end

          if request_routing_rules
            request_routing_rule_arr = define_request_routing_rules(request_routing_rules)
            ag_props.request_routing_rules = []
            ag_props.request_routing_rules = request_routing_rule_arr
          end

          gateway_sku = Azure::ARM::Network::Models::ApplicationGatewaySku.new
          gateway_sku.name = sku_name
          gateway_sku.tier = sku_tier
          gateway_sku.capacity = sku_capacity
          ag_props.sku = gateway_sku

          application_gateway = Azure::ARM::Network::Models::ApplicationGateway.new
          application_gateway.name = name
          application_gateway.location = location
          application_gateway.properties = ag_props

          application_gateway
        end

        def define_gateway_ip_configuration(gateway_ip_configurations)
          gateway_ip_configuration_arr = []
          gateway_ip_configurations.each do |ip_configuration|
            configuration = Azure::ARM::Network::Models::ApplicationGatewayIPConfiguration.new
            configuration_prop = Azure::ARM::Network::Models::ApplicationGatewayIPConfigurationPropertiesFormat.new
            configuration_prop.provisioning_state = ip_configuration[:provisioning_state]
            if ip_configuration[:subnet_id]
              subnet = Azure::ARM::Network::Models::Subnet.new
              subnet.id = ip_configuration[:subnet_id]
              configuration_prop.subnet = subnet
            end

            configuration.name = ip_configuration[:name]
            configuration.properties = configuration_prop
            gateway_ip_configuration_arr.push(configuration)
          end
          gateway_ip_configuration_arr
        end

        def define_ssl_certificate(ssl_certificates)
          ssl_certificate_arr = []
          ssl_certificates.each do |ssl_certificate|
            certificate = Azure::ARM::Network::Models::ApplicationGatewaySslCertificate.new
            certificate_prop = Azure::ARM::Network::Models::ApplicationGatewaySslCertificatePropertiesFormat.new
            certificate_prop.data = ssl_certificate[:data]
            certificate_prop.password = ssl_certificate[:password]
            certificate_prop.public_cert_data = ssl_certificate[:public_cert_data]

            certificate.name = ssl_certificate[:name]
            certificate.properties = certificate_prop
            ssl_certificate_arr.push(ssl_certificate)
          end
          ssl_certificate_arr
        end

        def define_frontend_ip_configurations(frontend_ip_configurations)
          frontend_ip_configuration_arr = []
          frontend_ip_configurations.each do |fic|
            frontend_ip_configuration = Azure::ARM::Network::Models::ApplicationGatewayFrontendIPConfiguration.new
            frontend_ip_configuration_prop = Azure::ARM::Network::Models::ApplicationGatewayFrontendIPConfigurationPropertiesFormat.new

            frontend_ip_configuration_prop.private_ipaddress = fic[:private_ip_address]
            frontend_ip_configuration_prop.private_ipallocation_method = fic[:private_ip_allocation_method]

            unless fic[:public_ip_address_id].nil?
              pip = Azure::ARM::Network::Models::PublicIPAddress.new
              pip.id = fic[:public_ip_address_id]
              frontend_ip_configuration_prop.public_ipaddress = pip
            end

            frontend_ip_configuration.name = fic[:name]
            frontend_ip_configuration.properties = frontend_ip_configuration_prop

            frontend_ip_configuration_arr.push(frontend_ip_configuration)
          end
          frontend_ip_configuration_arr
        end

        def define_frontend_ports(frontend_ports)
          frontend_port_arr = []
          frontend_ports.each do |port|
            frontend_port = Azure::ARM::Network::Models::ApplicationGatewayFrontendPort.new
            frontend_port_prop = Azure::ARM::Network::Models::ApplicationGatewayFrontendPortPropertiesFormat.new

            frontend_port_prop.port = port[:port]
            frontend_port.name = port[:name]
            frontend_port.properties = frontend_port_prop

            frontend_port_arr.push(frontend_port)
          end
          frontend_port_arr
        end

        def define_probes(probes)
          probe_arr = []
          probes.each do |probe|
            ag_probe = Azure::ARM::Network::Models::ApplicationGatewayProbe.new
            ag_probe_prop = Azure::ARM::Network::Models::ApplicationGatewayProbePropertiesFormat.new
            ag_probe_prop.protocol = probe[:protocol]
            ag_probe_prop.host = probe[:host]
            ag_probe_prop.path = probe[:path]
            ag_probe_prop.interval = probe[:interval]
            ag_probe_prop.timeout = probe[:timeout]
            ag_probe_prop.unhealthy_threshold = probe[:unhealthy_threshold]

            ag_probe.name = probe[:name]
            ag_probe.properties = ag_probe_prop
            probe_arr.push(ag_probe)
          end
          probe_arr
        end

        def define_backend_address_pools(backend_address_pools)
          backend_address_pool_arr = []

          backend_address_pools.each do |bap|
            backend_pool = Azure::ARM::Network::Models::ApplicationGatewayBackendAddressPool.new
            backend_pool_prop = Azure::ARM::Network::Models::ApplicationGatewayBackendAddressPoolPropertiesFormat.new

            backend_addresses1 = bap[:ip_addresses]

            addresses = []
            backend_addresses1.each do |address|
              backend_add = Azure::ARM::Network::Models::ApplicationGatewayBackendAddress.new
              backend_add.ip_address = address[:ipAddress]
              addresses.push(backend_add)
            end
            backend_pool_prop.backend_addresses = addresses

            backend_pool.name = bap[:name]
            backend_pool.properties = backend_pool_prop
            backend_address_pool_arr.push(backend_pool)
          end
          backend_address_pool_arr
        end

        def define_backend_http_settings(backend_http_settings_list)
          backend_http_setting_arr = []

          backend_http_settings_list.each do |http_setting|
            backend_http_setting = Azure::ARM::Network::Models::ApplicationGatewayBackendHttpSettings.new
            backend_http_setting_prop = Azure::ARM::Network::Models::ApplicationGatewayBackendHttpSettingsPropertiesFormat.new
            backend_http_setting_prop.port = http_setting[:port]
            backend_http_setting_prop.protocol = http_setting[:protocol]
            backend_http_setting_prop.cookie_based_affinity = http_setting[:cookie_based_affinity]
            backend_http_setting_prop.request_timeout = http_setting[:request_timeout]
            if http_setting[:probe]
              probe = Azure::ARM::Network::Models::Probe.new
              probe.id = http_setting[:probe]
              backend_http_setting_prop.probe = probe
            end

            backend_http_setting.name = http_setting[:name]
            backend_http_setting.properties = backend_http_setting_prop
            backend_http_setting_arr.push(backend_http_setting)
          end
          backend_http_setting_arr
        end

        def define_http_listeners(http_listeners)
          http_listener_arr = []

          http_listeners.each do |listener|
            http_listener = Azure::ARM::Network::Models::ApplicationGatewayHttpListener.new
            http_listener_prop = Azure::ARM::Network::Models::ApplicationGatewayHttpListenerPropertiesFormat.new

            http_listener_prop.protocol = listener[:protocol]
            http_listener_prop.host_name = listener[:host_name]
            http_listener_prop.require_server_name_indication = listener[:require_server_name_indication]
            if listener[:frontend_ip_config_id]
              frontend_ip = Azure::ARM::Network::Models::FrontendIPConfiguration.new
              frontend_ip.id = listener[:frontend_ip_config_id]
              http_listener_prop.frontend_ipconfiguration = frontend_ip
            end
            if listener[:frontend_port_id]
              frontend_port = Azure::ARM::Network::Models::ApplicationGatewayFrontendPort.new
              frontend_port.id = listener[:frontend_port_id]
              http_listener_prop.frontend_port = frontend_port
            end
            if listener[:ssl_certificate_id]
              ssl_cert = Azure::ARM::Network::Models::ApplicationGatewaySslCertificate.new
              ssl_cert.id = listener[:ssl_certificate_id]
              http_listener_prop.ssl_certificate = ssl_cert
            end

            http_listener.name = listener[:name]
            http_listener.properties = http_listener_prop
            http_listener_arr.push(http_listener)
          end
          http_listener_arr
        end

        def define_url_path_maps(url_path_maps)
          url_path_map_arr = []

          url_path_maps.each do |map|
            url_path_map = Azure::ARM::Network::Models::ApplicationGatewayUrlPathMap.new
            url_path_map_prop = Azure::ARM::Network::Models::ApplicationGatewayUrlPathMapPropertiesFormat.new

            if map[:default_backend_address_pool_id]
              default_backend_address_pool = Azure::ARM::Network::Models::BackendAddressPool.new
              default_backend_address_pool.id = map[:default_backend_address_pool_id]
              url_path_map_prop.default_backend_address_pool = default_backend_address_pool
            end
            if map[:default_backend_http_settings_id]
              default_backend_http_setting = Azure::ARM::Network::Models::ApplicationGatewayBackendHttpSettings.new
              default_backend_http_setting.id = map[:default_backend_http_settings_id]
              url_path_map_prop.default_backend_http_settings = default_backend_http_setting
            end

            if map[:path_rules]
              path_rules = map[:path_rules]
              path_rule_arr = define_path_rules(path_rules)
              url_path_map_prop.path_rules = path_rule_arr
            end

            url_path_map.name = map[:name]
            url_path_map.properties = url_path_map_prop
            url_path_map_arr.push(url_path_map)
          end
          url_path_map_arr
        end

        def define_path_rules(path_rules)
          path_rule_arr = []
          path_rules.each do |rule|
            path_rule = Azure::ARM::Network::Models::ApplicationGatewayPathRule.new
            path_rule_prop = Azure::ARM::Network::Models::ApplicationGatewayPathRulePropertiesFormat.new
            if rule[:backend_address_pool_id]
              backend_address_pool = Azure::ARM::Network::Models::BackendAddressPool.new
              backend_address_pool.id = rule[:backend_address_pool_id]
              path_rule_prop.backend_address_pool = backend_address_pool
            end
            if rule[:backend_http_settings_id]
              backend_http_setting = Azure::ARM::Network::Models::ApplicationGatewayBackendHttpSettings.new
              backend_http_setting.id = rule[:backend_http_settings_id]
              path_rule_prop.backend_http_settings = backend_http_setting
            end
            path_urls = rule[:paths]

            paths = []
            path_urls.each do |url|
              paths.push(url)
            end
            path_rule_prop.paths = paths

            path_rule.name = rule[:name]
            path_rule.properties = path_rule_prop
            path_rule_arr.push(path_rule)
          end
          path_rule_arr
        end

        def define_request_routing_rules(request_routing_rules)
          request_routing_rule_arr = []

          request_routing_rules.each do |rule|
            request_routing_rule = Azure::ARM::Network::Models::ApplicationGatewayRequestRoutingRule.new
            request_routing_rule_prop = Azure::ARM::Network::Models::ApplicationGatewayRequestRoutingRulePropertiesFormat.new

            request_routing_rule_prop.rule_type = rule[:type]
            if rule[:http_listener_id]
              http_listener = Azure::ARM::Network::Models::ApplicationGatewayHttpListener.new
              http_listener.id = rule[:http_listener_id]
              request_routing_rule_prop.http_listener = http_listener
            end
            if rule[:backend_address_pool_id]
              backend_address_pool = Azure::ARM::Network::Models::BackendAddressPool.new
              backend_address_pool.id = rule[:backend_address_pool_id]
              request_routing_rule_prop.backend_address_pool = backend_address_pool
            end
            if rule[:backend_http_settings_id]
              backend_http_setting = Azure::ARM::Network::Models::ApplicationGatewayBackendHttpSettings.new
              backend_http_setting.id = rule[:backend_http_settings_id]
              request_routing_rule_prop.backend_http_settings = backend_http_setting
            end

            request_routing_rule.name = rule[:name]
            request_routing_rule.properties = request_routing_rule_prop
            request_routing_rule_arr.push(request_routing_rule)
          end
          request_routing_rule_arr
        end
      end

      # Mock class for Network Request
      class Mock
        def create_application_gateway(_name, _location, _resource_group, _sku_name, _sku_tier, _sku_capacity, _gateway_ip_configurations, _ssl_certificates, _frontend_ip_configurations, _frontend_ports, _probes, _backend_address_pools, _backend_http_settings_list, _http_listeners, _url_path_maps, _request_routing_rules)
        end
      end
    end
  end
end
