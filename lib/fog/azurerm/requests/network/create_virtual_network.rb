module Fog
  module Network
    class AzureRM
      class Real
        def create_virtual_network(resource_group, name, location, dns_list, subnet_address_list, network_address_list)
          Fog::Logger.debug "Creating Virtual Network: #{name}..."
          virtual_network = define_vnet_object(location, name, network_address_list, dns_list, subnet_address_list)
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

        def define_vnet_object(location, network_name, network_address_list, dns_list, subnet_address_list)
          virtual_network = Azure::ARM::Network::Models::VirtualNetwork.new
          virtual_network.location = location
          virtual_network_properties = Azure::ARM::Network::Models::VirtualNetworkPropertiesFormat.new

          if network_address_list.nil?
            address_space = Azure::ARM::Network::Models::AddressSpace.new
            address_space.address_prefixes = ['10.2.0.0/16']
            virtual_network_properties.address_space = address_space
          else
            network_address_list = network_address_list.split(',')
            na_list = []
            (0...network_address_list.length).each do |i|
              na_list.push(network_address_list[i].strip)
            end
            address_space = Azure::ARM::Network::Models::AddressSpace.new
            address_space.address_prefixes = na_list
            virtual_network_properties.address_space = address_space
          end

          unless dns_list.nil?
            dns_list = dns_list.split(',')
            ns_list = []
            (0...dns_list.length).each do |i|
              ns_list.push(dns_list[i].strip)
            end
            dhcp_options = Azure::ARM::Network::Models::DhcpOptions.new
            dhcp_options.dns_servers = ns_list unless ns_list.nil?
            virtual_network_properties.dhcp_options = dhcp_options
          end

          unless subnet_address_list.nil?
            subnet_address_list = subnet_address_list.split(',')
            sub_nets = define_subnet_objects(network_name, subnet_address_list)
            virtual_network_properties.subnets = sub_nets
          end

          virtual_network.properties = virtual_network_properties
          virtual_network
        end

        def define_subnet_objects(network_name, subnet_address_list)
          sub_nets = []
          (0...subnet_address_list.length).each do |i|
            subnet_properties = Azure::ARM::Network::Models::SubnetPropertiesFormat.new
            subnet_properties.address_prefix = subnet_address_list[i].strip

            subnet = Azure::ARM::Network::Models::Subnet.new
            subnet.name = 'subnet_' + i.to_s + '_' + network_name
            subnet.properties = subnet_properties
            sub_nets.push(subnet)
          end
          sub_nets
        end
      end

      class Mock
        def create_virtual_network(resource_group, name, location, dns_list, subnet_address_list, network_address_list)
          {
            'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}/providers/Microsoft.Network/virtualNetworks/#{name}",
            'name' => name,
            'type' => 'Microsoft.Network/virtualNetworks',
            'location' => location,
            'properties' =>
              {
                'addressSpace' =>
                  {
                    'addressPrefixes' =>
                      [
                          network_address_list
                      ]
                  },
                'subnets' =>
                  [
                    {
                      'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{resource_group}providers/Microsoft.Network/virtualNetworks/#{name}/subnets/subnet_0_#{name}",
                      'properties' =>
                        {
                          'addressPrefix' => subnet_address_list,
                          'provisioningState' => 'Succeeded'
                        },
                      'name' => "subnet_0_#{name}",
                      'etag' => "W/\"ffbb0f61-b2bb-404e-9d20-79d854536f62\""
                     }
                  ],
                'resourceGuid' => 'c573f8e2-d916-493f-8b25-a681c31269ef',
                'provisioningState' => 'Succeeded'
              },
            'etag' => "W/\"ffbb0f61-b2bb-404e-9d20-79d854536f62\""
          }
        end
      end
    end
  end
end
