module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def create_virtual_network(resource_group, name, location, dns_servers, subnets, address_prefixes)
          Fog::Logger.debug "Creating Virtual Network: #{name}"
          virtual_network = define_vnet_object(location, address_prefixes, dns_servers, subnets)
          begin
            promise = @network_client.virtual_networks.create_or_update(resource_group, name, virtual_network)
            result = promise.value!
            Fog::Logger.debug "Virtual Network #{name} created successfully."
            Azure::ARM::Network::Models::VirtualNetwork.serialize_object(result.body)
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Exception creating Virtual Network #{name} in Resource Group: #{resource_group}. #{e.body['error']['message']}"
            raise msg
          end
        end

        private

        def define_vnet_object(location, address_prefixes, dns_servers, subnets)
          virtual_network = Azure::ARM::Network::Models::VirtualNetwork.new
          virtual_network.location = location
          virtual_network_properties = Azure::ARM::Network::Models::VirtualNetworkPropertiesFormat.new

          if address_prefixes.nil? || !address_prefixes.any?
            address_space = Azure::ARM::Network::Models::AddressSpace.new
            address_space.address_prefixes = DEFAULT_ADDRESS_PREFIXES
          else
            address_space = Azure::ARM::Network::Models::AddressSpace.new
            address_space.address_prefixes = address_prefixes
          end
          virtual_network_properties.address_space = address_space

          if !dns_servers.nil? && dns_servers.any?
            dhcp_options = Azure::ARM::Network::Models::DhcpOptions.new
            dhcp_options.dns_servers = dns_servers
            virtual_network_properties.dhcp_options = dhcp_options
          end

          if !subnets.nil? && subnets.any?
            subnet_objects = define_subnet_objects(subnets)
            virtual_network_properties.subnets = subnet_objects
          end

          virtual_network.properties = virtual_network_properties
          virtual_network
        end

        def define_subnet_objects(subnets)
          subnet_objects = []
          subnets.each do |subnet|
            network_security_group = Azure::ARM::Network::Models::NetworkSecurityGroup.new
            network_security_group.id = subnet[:network_security_group_id]

            route_table = Azure::ARM::Network::Models::RouteTable.new
            route_table.id = subnet[:route_table_id]

            subnet_properties = Azure::ARM::Network::Models::SubnetPropertiesFormat.new
            subnet_properties.address_prefix = subnet[:address_prefix]
            subnet_properties.network_security_group = network_security_group unless subnet[:network_security_group_id].nil?
            subnet_properties.route_table = route_table unless subnet[:route_table_id].nil?

            subnet_object = Azure::ARM::Network::Models::Subnet.new
            subnet_object.name = subnet[:name]
            subnet_object.properties = subnet_properties
            subnet_objects << subnet_object
          end
          subnet_objects
        end
      end

      # Mock class for Network Request
      class Mock
        def create_virtual_network(*)
          {
            'id' => '/subscriptions/########-####-####-####-############/resourceGroups/fog-rg/providers/Microsoft.Network/virtualNetworks/fog-vnet',
            'name' => 'fog-vnet',
            'type' => 'Microsoft.Network/virtualNetworks',
            'location' => 'westus',
            'properties' =>
              {
                'addressSpace' =>
                  {
                    'addressPrefixes' =>
                      [
                        '10.1.0.0/16',
                        '10.2.0.0/16'
                      ]
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
        end
      end
    end
  end
end
