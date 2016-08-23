module Fog
  module Network
    class AzureRM
      # VirtualNetworkGateway model class for Network Service
      class VirtualNetworkGateway < Fog::Model
        identity :name
        attribute :id
        attribute :location
        attribute :resource_group
        attribute :tags
        attribute :gateway_type
        attribute :gateway_size
        attribute :vpn_type
        attribute :enable_bgp
        attribute :provisioning_state
        attribute :sku_name
        attribute :sku_tier
        attribute :sku_capacity
        attribute :ip_configurations
        attribute :asn
        attribute :bgp_peering_address
        attribute :peer_weight
        attribute :vpn_client_configuration
        attribute :gateway_default_site
        attribute :vpn_client_address_pool
        attribute :default_sites

        def self.parse(network_gateway)
          hash = {}
          hash['id'] = network_gateway['id']
          hash['name'] = network_gateway['name']
          hash['location'] = network_gateway['location']
          hash['resource_group'] = get_resource_group_from_id(network_gateway['id'])
          hash['tags'] = network_gateway['tags']
          gateway_properties = network_gateway['properties']

          unless gateway_properties['sku'].nil?
            hash['sku_name'] = gateway_properties['sku']['name']
            hash['sku_tier'] = gateway_properties['sku']['tier']
            hash['sku_capacity'] = gateway_properties['sku']['capacity']
          end
          hash['gateway_type'] = gateway_properties['gatewayType']
          hash['gateway_size'] = gateway_properties['gatewaySize']
          hash['gateway_default_site'] = gateway_properties['gatewayDefaultSite']
          hash['vpn_type'] = gateway_properties['vpnType']
          hash['enable_bgp'] = gateway_properties['enableBgp']
          hash['provisioning_state'] = gateway_properties['provisioningState']
          bgp_settings = gateway_properties['bgpSettings']
          unless bgp_settings.nil?
            hash['asn'] = bgp_settings['asn']
            hash['bgp_peering_address'] = bgp_settings['bgpPeeringAddress']
            hash['peer_weight'] = bgp_settings['peerWeight']
          end

          hash['vpn_client_address_pool'] = []
          gateway_properties['vpnClientAddressPool'].each do |address_pool|
            hash['vpn_client_address_pool'] << address_pool
          end unless gateway_properties['vpnClientAddressPool'].nil?

          hash['default_sites'] = []
          gateway_properties['defaultSites'].each do |site|
            hash['default_sites'] << site
          end unless gateway_properties['defaultSites'].nil?

          hash['ip_configurations'] = []
          gateway_properties['ipConfigurations'].each do |ip_config|
            ip_configuration = Fog::Network::AzureRM::FrontendIPConfiguration.new
            hash['ip_configurations'] << ip_configuration.merge_attributes(Fog::Network::AzureRM::FrontendIPConfiguration.parse(ip_config))
          end unless gateway_properties['ipConfigurations'].nil?

          unless gateway_properties['vpnClientConfiguration'].nil?
            vpn_client_configuration = Fog::Network::AzureRM::VpnClientConfiguration.new
            hash['vpn_client_configuration'] = vpn_client_configuration.merge_attributes(Fog::Network::AzureRM::VpnClientConfiguration.parse(gateway_properties['vpnClientConfiguration']))
          end

          hash
        end

        def save
          requires :name, :location, :resource_group, :gateway_type, :gateway_size, :enable_bgp, :gateway_default_site
          validate_ip_configurations(ip_configurations) unless ip_configurations.nil?
          virtual_network_params = get_virtual_gateway_parameters
          network_gateway = service.create_or_update_virtual_network_gateway(virtual_network_params)
          merge_attributes(Fog::Network::AzureRM::VirtualNetworkGateway.parse(network_gateway))
        end

        def destroy
          service.delete_virtual_network_gateway(resource_group, name)
        end

        private

        def get_virtual_gateway_parameters
          {
            resource_group_name: resource_group,
            name: name,
            location: location,
            tags: tags,
            gateway_type: gateway_type,
            gateway_size: gateway_size,
            vpn_type: vpn_type,
            enable_bgp: enable_bgp,
            provisioning_state: provisioning_state,
            sku_name: sku_name,
            sku_tier: sku_tier,
            sku_capacity: sku_capacity,
            vpn_client_address_pool: vpn_client_address_pool,
            default_sites: default_sites,
            gateway_default_site: gateway_default_site,
            ip_configurations: ip_configurations,
            vpn_client_configuration: vpn_client_configuration,
            asn: asn,
            bgp_peering_address: bgp_peering_address,
            peer_weight: peer_weight
          }
        end

        def validate_ip_configurations(ip_configurations)
          unless ip_configurations.is_a?(Array)
            raise(ArgumentError, ':ip_configurations must be an Array')
          end
          unless ip_configurations.any?
            raise(ArgumentError, ':ip_configurations must not be an empty Array')
          end
          ip_configurations.each do |ip_configuration|
            if ip_configuration.is_a?(Hash)
              validate_ip_configuration_params(ip_configuration)
            else
              raise(ArgumentError, ':ip_configurations must be an Array of Hashes')
            end
          end
        end

        def validate_ip_configuration_params(ip_configuration)
          required_params = [
            :name,
            :private_ipallocation_method
          ]
          missing = required_params.select { |p| p unless ip_configuration.key?(p) }
          if missing.length == 1 || missing.any?
            raise(ArgumentError, "#{missing[0...-1].join(', ')} and #{missing[-1]} are required for this operation")
          end
          unless ip_configuration.key?(:subnet_id) || ip_configuration.key?(:public_ipaddress_id)
            raise(ArgumentError, 'subnet_id and public_id can not be empty at the same time.')
          end
        end
      end
    end
  end
end
