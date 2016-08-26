module Fog
  module ApplicationGateway
    class AzureRM
      # Gateway model class for Application Gateway Service
      class Gateway < Fog::Model
        identity :name
        attribute :id
        attribute :location
        attribute :resource_group
        attribute :provisioning_state
        attribute :sku_name
        attribute :sku_tier
        attribute :sku_capacity
        attribute :operational_state
        attribute :gateway_ip_configurations
        attribute :ssl_certificates
        attribute :frontend_ip_configurations
        attribute :frontend_ports
        attribute :probes
        attribute :backend_address_pools
        attribute :backend_http_settings_list
        attribute :http_listeners
        attribute :url_path_maps
        attribute :request_routing_rules

        def self.parse(gateway)
          hash = {}
          hash['name'] = gateway.name
          hash['id'] = gateway.id
          hash['location'] = gateway.location
          hash['resource_group'] = get_resource_group_from_id(gateway.id)
          hash['provisioning_state'] = gateway.provisioning_state
          unless gateway.sku.nil?
            hash['sku_name'] = gateway.sku.name
            hash['sku_tier'] = gateway.sku.tier
            hash['sku_capacity'] = gateway.sku.capacity
          end
          hash['operational_state'] = gateway.operational_state

          hash['gateway_ip_configurations'] = []
          gateway.gateway_ipconfigurations.each do |ip_configuration|
            gateway_ip_configuration = Fog::ApplicationGateway::AzureRM::IPConfiguration.new
            hash['gateway_ip_configurations'] << gateway_ip_configuration.merge_attributes(Fog::ApplicationGateway::AzureRM::IPConfiguration.parse(ip_configuration))
          end unless gateway.gateway_ipconfigurations.nil?

          hash['ssl_certificates'] = []
          gateway.ssl_certificates.each do |certificate|
            ssl_certificate = Fog::ApplicationGateway::AzureRM::SslCertificate.new
            hash['ssl_certificates'] << ssl_certificate.merge_attributes(Fog::ApplicationGateway::AzureRM::SslCertificate.parse(certificate))
          end unless gateway.ssl_certificates.nil?

          hash['frontend_ip_configurations'] = []
          gateway.frontend_ipconfigurations.each do |frontend_ip_config|
            frontend_ip_configuration = Fog::ApplicationGateway::AzureRM::FrontendIPConfiguration.new
            hash['frontend_ip_configurations'] << frontend_ip_configuration.merge_attributes(Fog::ApplicationGateway::AzureRM::FrontendIPConfiguration.parse(frontend_ip_config))
          end unless gateway.frontend_ipconfigurations.nil?

          hash['frontend_ports'] = []
          gateway.frontend_ports.each do |port|
            frontend_port = Fog::ApplicationGateway::AzureRM::FrontendPort.new
            hash['frontend_ports'] << frontend_port.merge_attributes(Fog::ApplicationGateway::AzureRM::FrontendPort.parse(port))
          end unless gateway.frontend_ports.nil?

          hash['probes'] = []
          gateway.probes.each do |probe|
            gateway_probe = Fog::ApplicationGateway::AzureRM::Probe.new
            hash['probes'] << gateway_probe.merge_attributes(Fog::ApplicationGateway::AzureRM::Probe.parse(probe))
          end unless gateway.probes.nil?

          hash['backend_address_pools'] = []
          gateway.backend_address_pools.each do |address|
            backend_address_pool = Fog::ApplicationGateway::AzureRM::BackendAddressPool.new
            hash['backend_address_pools'] << backend_address_pool.merge_attributes(Fog::ApplicationGateway::AzureRM::BackendAddressPool.parse(address))
          end unless gateway.backend_address_pools.nil?

          hash['backend_http_settings_list'] = []
          gateway.backend_http_settings_collection.each do |http_setting|
            backend_http_setting = Fog::ApplicationGateway::AzureRM::BackendHttpSetting.new
            hash['backend_http_settings_list'] << backend_http_setting.merge_attributes(Fog::ApplicationGateway::AzureRM::BackendHttpSetting.parse(http_setting))
          end unless gateway.backend_http_settings_collection.nil?

          hash['http_listeners'] = []
          gateway.http_listeners.each do |listener|
            http_listener = Fog::ApplicationGateway::AzureRM::HttpListener.new
            hash['http_listeners'] << http_listener.merge_attributes(Fog::ApplicationGateway::AzureRM::HttpListener.parse(listener))
          end unless gateway.http_listeners.nil?

          hash['url_path_maps'] = []
          gateway.url_path_maps.each do |map|
            url_path_map = Fog::ApplicationGateway::AzureRM::UrlPathMap.new
            hash['url_path_maps'] << url_path_map.merge_attributes(Fog::ApplicationGateway::AzureRM::UrlPathMap.parse(map))
          end unless gateway.url_path_maps.nil?

          hash['request_routing_rules'] = []
          gateway.request_routing_rules.each do |rule|
            request_routing_rule = Fog::ApplicationGateway::AzureRM::RequestRoutingRule.new
            hash['request_routing_rules'] << request_routing_rule.merge_attributes(Fog::ApplicationGateway::AzureRM::RequestRoutingRule.parse(rule))
          end unless gateway.request_routing_rules.nil?
          hash
        end

        def save
          requires :name, :location, :resource_group, :sku_name, :sku_tier, :sku_capacity, :gateway_ip_configurations, :frontend_ip_configurations, :frontend_ports, :backend_address_pools, :backend_http_settings_list, :http_listeners, :request_routing_rules

          validate_gateway_ip_configurations(gateway_ip_configurations) unless gateway_ip_configurations.nil?
          validate_ssl_certificates(ssl_certificates) unless ssl_certificates.nil?
          validate_frontend_ip_configurations(frontend_ip_configurations) unless frontend_ip_configurations.nil?
          validate_frontend_ports(frontend_ports) unless frontend_ports.nil?
          validate_probes(probes) unless probes.nil?
          validate_backend_address_pools(backend_address_pools) unless backend_address_pools.nil?
          validate_backend_http_settings_list(backend_http_settings_list) unless backend_http_settings_list.nil?
          validate_http_listeners(http_listeners) unless http_listeners.nil?
          validate_url_path_maps(url_path_maps) unless url_path_maps.nil?
          validate_request_routing_rules(request_routing_rules) unless request_routing_rules.nil?

          gateway = service.create_application_gateway(name, location, resource_group, sku_name, sku_tier, sku_capacity, gateway_ip_configurations, ssl_certificates, frontend_ip_configurations, frontend_ports, probes, backend_address_pools, backend_http_settings_list, http_listeners, url_path_maps, request_routing_rules)
          merge_attributes(Fog::ApplicationGateway::AzureRM::Gateway.parse(gateway))
        end

        def validate_gateway_ip_configurations(gateway_ip_configurations)
          if gateway_ip_configurations.is_a?(Array)
            if gateway_ip_configurations.any?
              gateway_ip_configurations.each do |gateway_ip_configuration|
                if gateway_ip_configuration.is_a?(Hash)
                  validate_gateway_ip_configuration_params(gateway_ip_configuration)
                else
                  raise(ArgumentError, ':gateway_ip_configurations must be an Array of Hashes')
                end
              end
            else
              raise(ArgumentError, ':gateway_ip_configurations must not be an empty Array')
            end
          else
            raise(ArgumentError, ':gateway_ip_configurations must be an Array')
          end
        end

        def validate_gateway_ip_configuration_params(gateway_ip_configuration)
          required_params = [
            :name,
            :subnet_id
          ]
          missing = required_params.select { |p| p unless gateway_ip_configuration.key?(p) }
          if missing.length == 1
            raise(ArgumentError, "#{missing.first} is required for this operation")
          elsif missing.any?
            raise(ArgumentError, "#{missing[0...-1].join(', ')} and #{missing[-1]} are required for this operation")
          end
        end

        def validate_ssl_certificates(ssl_certificates)
          if ssl_certificates.is_a?(Array)
            if ssl_certificates.any?
              ssl_certificates.each do |ssl_certificate|
                if ssl_certificate.is_a?(Hash)
                  validate_ssl_certificate_params(ssl_certificate)
                else
                  raise(ArgumentError, ':ssl_certificates must be an Array of Hashes')
                end
              end
            else
              raise(ArgumentError, ':ssl_certificates must not be an empty Array')
            end
          else
            raise(ArgumentError, ':ssl_certificates must be an Array')
          end
        end

        def validate_ssl_certificate_params(ssl_certificate)
          required_params = [
            :name,
            :data,
            :password,
            :public_cert_data
          ]
          missing = required_params.select { |p| p unless ssl_certificate.key?(p) }
          if missing.length == 1
            raise(ArgumentError, "#{missing.first} is required for this operation")
          elsif missing.any?
            raise(ArgumentError, "#{missing[0...-1].join(', ')} and #{missing[-1]} are required for this operation")
          end
        end

        def validate_frontend_ip_configurations(frontend_ip_configurations)
          if frontend_ip_configurations.is_a?(Array)
            if frontend_ip_configurations.any?
              frontend_ip_configurations.each do |frontend_ip_configuration|
                if frontend_ip_configuration.is_a?(Hash)
                  validate_frontend_ip_configuration_params(frontend_ip_configuration)
                else
                  raise(ArgumentError, ':frontend_ip_configurations must be an Array of Hashes')
                end
              end
            else
              raise(ArgumentError, ':frontend_ip_configurations must not be an empty Array')
            end
          else
            raise(ArgumentError, ':frontend_ip_configurations must be an Array')
          end
        end

        def validate_frontend_ip_configuration_params(frontend_ip_configuration)
          required_params = [
            :name,
            :public_ip_address_id,
            :private_ip_allocation_method,
            :private_ip_address
          ]
          missing = required_params.select { |p| p unless frontend_ip_configuration.key?(p) }
          if missing.length == 1
            raise(ArgumentError, "#{missing.first} is required for this operation")
          elsif missing.any?
            raise(ArgumentError, "#{missing[0...-1].join(', ')} and #{missing[-1]} are required for this operation")
          end
        end

        def validate_frontend_ports(frontend_ports)
          if frontend_ports.is_a?(Array)
            if frontend_ports.any?
              frontend_ports.each do |frontend_port|
                if frontend_port.is_a?(Hash)
                  validate_frontend_port_params(frontend_port)
                else
                  raise(ArgumentError, ':frontend_ports must be an Array of Hashes')
                end
              end
            else
              raise(ArgumentError, ':frontend_ports must not be an empty Array')
            end
          else
            raise(ArgumentError, ':frontend_ports must be an Array')
          end
        end

        def validate_frontend_port_params(frontend_port)
          required_params = [
            :name,
            :port
          ]
          missing = required_params.select { |p| p unless frontend_port.key?(p) }
          if missing.length == 1
            raise(ArgumentError, "#{missing.first} is required for this operation")
          elsif missing.any?
            raise(ArgumentError, "#{missing[0...-1].join(', ')} and #{missing[-1]} are required for this operation")
          end
        end

        def validate_probes(probes)
          if probes.is_a?(Array)
            if probes.any?
              probes.each do |probe|
                if probe.is_a?(Hash)
                  validate_probe_params(probe)
                else
                  raise(ArgumentError, ':probes must be an Array of Hashes')
                end
              end
            else
              raise(ArgumentError, ':probes must not be an empty Array')
            end
          else
            raise(ArgumentError, ':probes must be an Array')
          end
        end

        def validate_probe_params(probe)
          required_params = [
            :name,
            :protocol,
            :host,
            :path,
            :interval,
            :timeout,
            :unhealthy_threshold
          ]
          missing = required_params.select { |p| p unless probe.key?(p) }
          if missing.length == 1
            raise(ArgumentError, "#{missing.first} is required for this operation")
          elsif missing.any?
            raise(ArgumentError, "#{missing[0...-1].join(', ')} and #{missing[-1]} are required for this operation")
          end
        end

        def validate_backend_address_pools(backend_address_pools)
          if backend_address_pools.is_a?(Array)
            if backend_address_pools.any?
              backend_address_pools.each do |backend_address_pool|
                if backend_address_pool.is_a?(Hash)
                  validate_backend_address_pool_params(backend_address_pool)
                else
                  raise(ArgumentError, ':backend_address_pools must be an Array of Hashes')
                end
              end
            else
              raise(ArgumentError, ':backend_address_pools must not be an empty Array')
            end
          else
            raise(ArgumentError, ':backend_address_pools must be an Array')
          end
        end

        def validate_backend_address_pool_params(backend_address_pool)
          required_params = [
            :name,
            :ip_addresses
          ]
          missing = required_params.select { |p| p unless backend_address_pool.key?(p) }
          if missing.length == 1
            raise(ArgumentError, "#{missing.first} is required for this operation")
          elsif missing.any?
            raise(ArgumentError, "#{missing[0...-1].join(', ')} and #{missing[-1]} are required for this operation")
          end
        end

        def validate_backend_http_settings_list(backend_http_settings_list)
          if backend_http_settings_list.is_a?(Array)
            if backend_http_settings_list.any?
              backend_http_settings_list.each do |backend_http_settings|
                if backend_http_settings.is_a?(Hash)
                  validate_backend_http_settings_params(backend_http_settings)
                else
                  raise(ArgumentError, ':backend_http_settings_list must be an Array of Hashes')
                end
              end
            else
              raise(ArgumentError, ':backend_http_settings_list must not be an empty Array')
            end
          else
            raise(ArgumentError, ':backend_http_settings_list must be an Array')
          end
        end

        def validate_backend_http_settings_params(backend_http_settings)
          required_params = [
            :name,
            :port,
            :protocol,
            :cookie_based_affinity,
            :request_timeout
          ]
          missing = required_params.select { |p| p unless backend_http_settings.key?(p) }
          if missing.length == 1
            raise(ArgumentError, "#{missing.first} is required for this operation")
          elsif missing.any?
            raise(ArgumentError, "#{missing[0...-1].join(', ')} and #{missing[-1]} are required for this operation")
          end
        end

        def validate_http_listeners(http_listeners)
          if http_listeners.is_a?(Array)
            if http_listeners.any?
              http_listeners.each do |http_listener|
                if http_listener.is_a?(Hash)
                  validate_http_listener_params(http_listener)
                else
                  raise(ArgumentError, ':http_listeners must be an Array of Hashes')
                end
              end
            else
              raise(ArgumentError, ':http_listeners must not be an empty Array')
            end
          else
            raise(ArgumentError, ':http_listeners must be an Array')
          end
        end

        def validate_http_listener_params(http_listener)
          required_params = [
            :name,
            :frontend_ip_config_id,
            :frontend_port_id,
            :protocol
          ]
          missing = required_params.select { |p| p unless http_listener.key?(p) }
          if missing.length == 1
            raise(ArgumentError, "#{missing.first} is required for this operation")
          elsif missing.any?
            raise(ArgumentError, "#{missing[0...-1].join(', ')} and #{missing[-1]} are required for this operation")
          end
        end

        def validate_url_path_maps(url_path_maps)
          if url_path_maps.is_a?(Array)
            if url_path_maps.any?
              url_path_maps.each do |url_path_map|
                if url_path_map.is_a?(Hash)
                  validate_url_path_map_params(url_path_map)
                else
                  raise(ArgumentError, ':url_path_maps must be an Array of Hashes')
                end
              end
            else
              raise(ArgumentError, ':url_path_maps must not be an empty Array')
            end
          else
            raise(ArgumentError, ':url_path_maps must be an Array')
          end
        end

        def validate_url_path_map_params(url_path_map)
          required_params = [
            :name,
            :default_backend_address_pool_id,
            :default_backend_http_settings_id,
            :path_rules
          ]
          missing = required_params.select { |p| p unless url_path_map.key?(p) }
          if missing.length == 1
            raise(ArgumentError, "#{missing.first} is required for this operation")
          elsif missing.any?
            raise(ArgumentError, "#{missing[0...-1].join(', ')} and #{missing[-1]} are required for this operation")
          end
        end

        def validate_request_routing_rules(request_routing_rules)
          if request_routing_rules.is_a?(Array)
            if request_routing_rules.any?
              request_routing_rules.each do |request_routing_rule|
                if request_routing_rule.is_a?(Hash)
                  validate_request_routing_rule_params(request_routing_rule)
                else
                  raise(ArgumentError, ':request_routing_rules must be an Array of Hashes')
                end
              end
            else
              raise(ArgumentError, ':request_routing_rules must not be an empty Array')
            end
          else
            raise(ArgumentError, ':request_routing_rules must be an Array')
          end
        end

        def validate_request_routing_rule_params(request_routing_rule)
          required_params = [
            :type,
            :http_listener_id
          ]
          missing = required_params.select { |p| p unless request_routing_rule.key?(p) }
          if missing.length == 1
            raise(ArgumentError, "#{missing.first} is required for this operation")
          elsif missing.any?
            raise(ArgumentError, "#{missing[0...-1].join(', ')} and #{missing[-1]} are required for this operation")
          end
        end

        def destroy
          service.delete_application_gateway(resource_group, name)
        end
      end
    end
  end
end
