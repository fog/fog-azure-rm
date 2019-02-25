module Fog
  module Network
    class AzureRM
      # NetworkInterface model class for Network Service
      class NetworkInterface < Fog::Model
        identity :name
        attribute :id
        attribute :location
        attribute :resource_group
        attribute :virtual_machine_id
        attribute :mac_address
        attribute :network_security_group_id
        attribute :ip_configuration_name
        attribute :ip_configuration_id
        attribute :subnet_id
        attribute :private_ip_allocation_method
        attribute :private_ip_address
        attribute :public_ip_address_id
        attribute :load_balancer_backend_address_pools_ids
        attribute :load_balancer_inbound_nat_rules_ids
        attribute :dns_servers
        attribute :applied_dns_servers
        attribute :internal_dns_name_label
        attribute :internal_fqd
        attribute :tags
        attribute :enable_accelerated_networking

        def self.parse(nic)
          hash = {}
          hash['id'] = nic.id
          hash['name'] = nic.name
          hash['location'] = nic.location
          hash['resource_group'] = get_resource_from_resource_id(nic.id, RESOURCE_GROUP_NAME)
          hash['virtual_machine_id'] = nic.virtual_machine.id unless nic.virtual_machine.nil?
          hash['mac_address'] = nic.mac_address unless nic.mac_address.nil?
          hash['network_security_group_id'] = nil
          hash['network_security_group_id'] = nic.network_security_group.id unless nic.network_security_group.nil?
          hash['tags'] = nic.tags
          ip_configuration = nic.ip_configurations[0] unless nic.ip_configurations.nil?
          unless ip_configuration.nil?
            hash['ip_configuration_name'] = ip_configuration.name
            hash['ip_configuration_id'] = ip_configuration.id
            hash['subnet_id'] = ip_configuration.subnet.id unless ip_configuration.subnet.nil?
            hash['private_ip_allocation_method'] = ip_configuration.private_ipallocation_method
            hash['private_ip_address'] = ip_configuration.private_ipaddress
            hash['public_ip_address_id'] = nil
            hash['public_ip_address_id'] = ip_configuration.public_ipaddress.id unless ip_configuration.public_ipaddress.nil?
            hash['load_balancer_backend_address_pools_ids'] = ip_configuration.load_balancer_backend_address_pools.map(&:id) unless ip_configuration.load_balancer_backend_address_pools.nil?
            hash['load_balancer_inbound_nat_rules_ids'] = ip_configuration.load_balancer_inbound_nat_rules.map(&:id) unless ip_configuration.load_balancer_inbound_nat_rules.nil?
          end
          nic_dns_settings = nic.dns_settings
          unless nic_dns_settings.nil?
            hash['dns_servers'] = nic_dns_settings.dns_servers
            hash['applied_dns_servers'] = nic_dns_settings.applied_dns_servers
            hash['internal_dns_name_label'] = nic_dns_settings.internal_dns_name_label
            hash['internal_fqd'] = nic_dns_settings.internal_fqdn
          end
          hash['enable_accelerated_networking'] = nic.enable_accelerated_networking
          hash
        end

        def save(async = false)
          requires :name
          requires :location
          requires :resource_group
          requires :subnet_id
          requires :ip_configuration_name
          requires :private_ip_allocation_method

          nic_response = service.create_or_update_network_interface(resource_group, name, location, subnet_id, public_ip_address_id, network_security_group_id, ip_configuration_name, private_ip_allocation_method, private_ip_address, load_balancer_backend_address_pools_ids, load_balancer_inbound_nat_rules_ids, tags, enable_accelerated_networking, async)

          if async
            nic_response
          else
            merge_attributes(Fog::Network::AzureRM::NetworkInterface.parse(nic_response))
          end
        end

        def update(updated_attributes = {})
          validate_update_attributes!(updated_attributes)
          merge_attributes(updated_attributes)
          nic = service.create_or_update_network_interface(resource_group, name, location, subnet_id, public_ip_address_id, network_security_group_id, ip_configuration_name, private_ip_allocation_method, private_ip_address)
          merge_attributes(Fog::Network::AzureRM::NetworkInterface.parse(nic))
        end

        def attach_subnet(subnet_id)
          raise 'Subnet ID can not be nil.' if subnet_id.nil?
          nic = service.attach_resource_to_nic(resource_group, name, SUBNET, subnet_id)
          merge_attributes(Fog::Network::AzureRM::NetworkInterface.parse(nic))
        end

        def attach_public_ip(public_ip_id)
          raise 'Public-IP ID can not be nil.' if public_ip_id.nil?
          nic = service.attach_resource_to_nic(resource_group, name, PUBLIC_IP, public_ip_id)
          merge_attributes(Fog::Network::AzureRM::NetworkInterface.parse(nic))
        end

        def attach_network_security_group(network_security_group_id)
          raise 'Network-Security-Group ID can not be nil.' if network_security_group_id.nil?
          nic = service.attach_resource_to_nic(resource_group, name, NETWORK_SECURITY_GROUP, network_security_group_id)
          merge_attributes(Fog::Network::AzureRM::NetworkInterface.parse(nic))
        end

        def detach_public_ip
          raise "Error detaching Public IP. No Public IP is attached to Network Interface #{name}" if public_ip_address_id.nil?
          nic = service.detach_resource_from_nic(resource_group, name, PUBLIC_IP)
          merge_attributes(Fog::Network::AzureRM::NetworkInterface.parse(nic))
        end

        def detach_network_security_group
          raise "Error detaching Network Security Group. No Security Group is attached to Network Interface #{name}" if network_security_group_id.nil?
          nic = service.detach_resource_from_nic(resource_group, name, NETWORK_SECURITY_GROUP)
          merge_attributes(Fog::Network::AzureRM::NetworkInterface.parse(nic))
        end

        def destroy
          service.delete_network_interface(resource_group, name)
        end

        def validate_update_attributes!(hash)
          restricted_attributes = [:name, :id, :resource_group, :location, :ip_configuration_name, :ip_configuration_id]
          hash_keys = hash.keys
          invalid_attributes = restricted_attributes & hash_keys
          raise "Attributes #{invalid_attributes.join(', ')} can not be updated." unless invalid_attributes.empty?
        end
      end
    end
  end
end
