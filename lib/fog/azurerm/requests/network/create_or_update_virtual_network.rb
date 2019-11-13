module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def create_or_update_virtual_network(resource_group_name, virtual_network_name, location, dns_servers, subnets, address_prefixes, tags)
          virtual_network = define_vnet_object(location, address_prefixes, dns_servers, subnets, tags)
          create_or_update_vnet(resource_group_name, virtual_network_name, virtual_network)
        end

        private

        def create_or_update_vnet(resource_group_name, virtual_network_name, virtual_network)
          msg = "Creating/Updating Virtual Network: #{virtual_network_name}"
          Fog::Logger.debug msg
          begin
            virtual_network = @network_client.virtual_networks.create_or_update(resource_group_name, virtual_network_name, virtual_network)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Virtual Network #{virtual_network_name} created/updated successfully."
          virtual_network
        end

        def define_vnet_object(location, address_prefixes, dns_servers, subnets, tags)
          virtual_network = Azure::Network::Profiles::Latest::Mgmt::Models::VirtualNetwork.new
          virtual_network.location = location
          virtual_network.tags = tags

          if address_prefixes.nil? || !address_prefixes.any?
            address_space = Azure::Network::Profiles::Latest::Mgmt::Models::AddressSpace.new
            address_space.address_prefixes = DEFAULT_ADDRESS_PREFIXES
          else
            address_space = Azure::Network::Profiles::Latest::Mgmt::Models::AddressSpace.new
            address_space.address_prefixes = address_prefixes
          end
          virtual_network.address_space = address_space

          if !dns_servers.nil? && dns_servers.any?
            dhcp_options = Azure::Network::Profiles::Latest::Mgmt::Models::DhcpOptions.new
            dhcp_options.dns_servers = dns_servers
            virtual_network.dhcp_options = dhcp_options
          end

          if !subnets.nil? && subnets.any?
            subnet_objects = define_subnet_objects(subnets)
            virtual_network.subnets = subnet_objects
          end

          virtual_network
        end

        def define_subnet_objects(subnets)
          subnet_objects = []
          subnets.each do |subnet|
            network_security_group = Azure::Network::Profiles::Latest::Mgmt::Models::NetworkSecurityGroup.new
            network_security_group.id = subnet[:network_security_group_id]

            route_table = Azure::Network::Profiles::Latest::Mgmt::Models::RouteTable.new
            route_table.id = subnet[:route_table_id]

            subnet_object = Azure::Network::Profiles::Latest::Mgmt::Models::Subnet.new
            subnet_object.name = subnet[:name]
            subnet_object.address_prefix = subnet[:address_prefix]
            subnet_object.network_security_group = network_security_group unless subnet[:network_security_group_id].nil?
            subnet_object.route_table = route_table unless subnet[:route_table_id].nil?

            subnet_objects << subnet_object
          end
          subnet_objects
        end
      end

      # Mock class for Network Request
      class Mock
        def create_or_update__virtual_network(*)
          virtual_network = {
            'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog-rg/providers/Microsoft.Network/virtualNetworks/fog-vnet',
            'name' => 'fog-vnet',
            'type' => 'Microsoft.Network/virtualNetworks',
            'location' => 'westus',
            'properties' =>
              {
                'addressSpace' =>
                  {
                    'addressPrefixes' =>
                      %w(10.1.0.0/16 10.2.0.0/16)
                  },
                'subnets' =>
                  [
                    {
                      'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog-rg/providers/Microsoft.Network/virtualNetworks/fog-vnet/subnets/fog-subnet',
                      'properties' =>
                        {
                          'addressPrefix' => [],
                          'provisioningState' => 'Succeeded'
                        },
                      'name' => "subnet_0_#{name}"
                    }
                  ],
                'resourceGuid' => 'c573f8e2-d916-493f-8b25-a681c31269ef',
                'provisioningState' => 'Succeeded'
              }
          }
          vnet_mapper = Azure::Network::Profiles::Latest::Mgmt::Models::VirtualNetwork.mapper
          @network_client.deserialize(vnet_mapper, virtual_network, 'result.body')
        end
      end
    end
  end
end
