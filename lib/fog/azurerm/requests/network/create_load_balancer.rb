module Fog
  module Network
    class AzureRM
      # Real class for Load-Balancer Request
      class Real
        def create_load_balancer(name, location, resource_group, frontend_ip_configurations, backend_address_pool_names, load_balancing_rules, probes, inbound_nat_rules, inbound_nat_pools, tags)
          msg = "Creating Load-Balancer: #{name}"
          Fog::Logger.debug msg
          load_balancer = define_load_balancer(name, location, frontend_ip_configurations, backend_address_pool_names, load_balancing_rules, probes, inbound_nat_rules, inbound_nat_pools, tags)
          begin
            load_balancer = @network_client.load_balancers.create_or_update(resource_group, name, load_balancer)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Load-Balancer #{name} created successfully."
          load_balancer
        end

        private

        def define_load_balancer(name, location, frontend_ip_configurations, backend_address_pool_names, load_balancing_rules, probes, inbound_nat_rules, inbound_nat_pools, tags)
          load_balancer = Azure::Network::Profiles::Latest::Mgmt::Models::LoadBalancer.new
          load_balancer.name = name
          load_balancer.location = location
          load_balancer.tags = tags
          if frontend_ip_configurations
            frontend_ip_configuration_arr = define_lb_frontend_ip_configurations(frontend_ip_configurations)
            load_balancer.frontend_ipconfigurations = frontend_ip_configuration_arr
          end

          if backend_address_pool_names
            load_balancer.backend_address_pools = []
            backend_address_pool_names.each do |bap|
              backend_pool = Azure::Network::Profiles::Latest::Mgmt::Models::BackendAddressPool.new
              backend_pool.name = bap
              load_balancer.backend_address_pools.push(backend_pool)
            end
          end

          if load_balancing_rules
            load_balancing_rule_arr = define_load_balancing_rule(load_balancing_rules)
            load_balancer.load_balancing_rules = load_balancing_rule_arr
          end

          if probes
            probe_arr = define_probe(probes)
            load_balancer.probes = probe_arr
          end

          if inbound_nat_rules
            inbound_nat_rule_arr = define_inbound_nat_rule(inbound_nat_rules)
            load_balancer.inbound_nat_rules = inbound_nat_rule_arr
          end

          if inbound_nat_pools
            inbound_nat_pool_arr = define_inbound_nat_pool(inbound_nat_pools)
            load_balancer.inbound_nat_pools = inbound_nat_pool_arr
          end

          load_balancer
        end

        def define_inbound_nat_pool(inbound_nat_pools)
          inbound_nat_pool_arr = []
          inbound_nat_pools.each do |inp|
            inbound_nat_pool = Azure::Network::Profiles::Latest::Mgmt::Models::InboundNatPool.new

            unless inp[:frontend_ip_configuration_id].nil?
              frontend_ipconfigurations = Azure::Network::Profiles::Latest::Mgmt::Models::FrontendIPConfiguration.new
              frontend_ipconfigurations.id = inp[:frontend_ip_configuration_id]
              inbound_nat_pool.frontend_ipconfiguration = frontend_ipconfigurations
            end

            inbound_nat_pool.protocol = inp[:protocol]
            inbound_nat_pool.frontend_port_range_start = inp[:frontend_port_range_start]
            inbound_nat_pool.frontend_port_range_end = inp[:frontend_port_range_end]
            inbound_nat_pool.backend_port = inp[:backend_port]

            inbound_nat_pool.name = inp[:name]
            inbound_nat_pool_arr.push(inbound_nat_pool)
          end
          inbound_nat_pool_arr
        end

        def define_inbound_nat_rule(inbound_nat_rules)
          inbound_nat_rule_arr = []
          inbound_nat_rules.each do |inr|
            inbound_nat_rule = Azure::Network::Profiles::Latest::Mgmt::Models::InboundNatRule.new

            unless inr[:frontend_ip_configuration_id].nil?
              frontend_ipconfigurations = Azure::Network::Profiles::Latest::Mgmt::Models::FrontendIPConfiguration.new
              frontend_ipconfigurations.id = inr[:frontend_ip_configuration_id]
              inbound_nat_rule.frontend_ipconfiguration = frontend_ipconfigurations
            end
            inbound_nat_rule.protocol = inr[:protocol]
            inbound_nat_rule.frontend_port = inr[:frontend_port]
            inbound_nat_rule.backend_port = inr[:backend_port]

            inbound_nat_rule.name = inr[:name]
            inbound_nat_rule_arr.push(inbound_nat_rule)
          end
          inbound_nat_rule_arr
        end

        def define_probe(probes)
          probe_arr = []
          probes.each do |prb|
            probe = Azure::Network::Profiles::Latest::Mgmt::Models::Probe.new

            probe.protocol = prb[:protocol]
            probe.port = prb[:port]
            probe.interval_in_seconds = prb[:interval_in_seconds]
            probe.number_of_probes = prb[:number_of_probes]
            probe.request_path = prb[:request_path]

            probe.name = prb[:name]
            probe_arr.push(probe)
          end
          probe_arr
        end

        def define_load_balancing_rule(load_balancing_rules)
          load_balancing_rule_arr = []
          load_balancing_rules.each do |lbr|
            load_balancing_rule = Azure::Network::Profiles::Latest::Mgmt::Models::LoadBalancingRule.new

            load_balancing_rule.protocol = lbr[:protocol]
            load_balancing_rule.load_distribution = lbr[:load_distribution]
            load_balancing_rule.idle_timeout_in_minutes = lbr[:idle_timeout_in_minutes]
            load_balancing_rule.frontend_port = lbr[:frontend_port]
            load_balancing_rule.backend_port = lbr[:backend_port]
            load_balancing_rule.enable_floating_ip = lbr[:enable_floating_ip]

            unless lbr[:frontend_ip_configuration_id].nil?
              frontend_ipconfigurations = Azure::Network::Profiles::Latest::Mgmt::Models::FrontendIPConfiguration.new
              frontend_ipconfigurations.id = lbr[:frontend_ip_configuration_id]
              load_balancing_rule.frontend_ipconfiguration = frontend_ipconfigurations
            end

            unless lbr[:backend_address_pool_id].nil?
              backend_address_pool = Azure::Network::Profiles::Latest::Mgmt::Models::BackendAddressPool.new
              backend_address_pool.id = lbr[:backend_address_pool_id]
              load_balancing_rule.backend_address_pool = backend_address_pool
            end

            unless lbr[:probe_id].nil?
              probe = Azure::Network::Profiles::Latest::Mgmt::Models::Probe.new
              probe.id = lbr[:probe_id]
              load_balancing_rule.probe = probe
            end

            load_balancing_rule.name = lbr[:name]
            load_balancing_rule_arr.push(load_balancing_rule)
          end
          load_balancing_rule_arr
        end

        def define_lb_frontend_ip_configurations(frontend_ip_configurations)
          frontend_ip_configuration_arr = []
          frontend_ip_configurations.each do |fic|
            frontend_ip_configuration = Azure::Network::Profiles::Latest::Mgmt::Models::FrontendIPConfiguration.new
            frontend_ip_configuration.private_ipaddress = fic[:private_ipaddress]
            frontend_ip_configuration.private_ipallocation_method = fic[:private_ipallocation_method]
            unless fic[:subnet_id].nil?
              snet = Azure::Network::Profiles::Latest::Mgmt::Models::Subnet.new
              snet.id = fic[:subnet_id]
              frontend_ip_configuration.subnet = snet
            end
            unless fic[:public_ipaddress_id].nil?
              pip = Azure::Network::Profiles::Latest::Mgmt::Models::PublicIPAddress.new
              pip.id = fic[:public_ipaddress_id]
              frontend_ip_configuration.public_ipaddress = pip
            end

            frontend_ip_configuration.name = fic[:name]
            frontend_ip_configuration_arr.push(frontend_ip_configuration)
          end
          frontend_ip_configuration_arr
        end
      end

      # Mock class for Load-Balancer Request
      class Mock
        def create_load_balancer(_name, _location, _resource_group, _frontend_ip_configuration_name, _subnet_id, _private_ip_address, _private_ip_allocation_method, _public_ip_address_id, _backend_address_pool_names, _load_balancing_rules, _probes, _inbound_nat_rules, _inbound_nat_pools)
        end
      end
    end
  end
end
