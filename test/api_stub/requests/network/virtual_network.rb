module ApiStub
  module Requests
    module Network
      class VirtualNetwork
        def self.create_virtual_network_response
          subnet_properties = Azure::ARM::Network::Models::SubnetPropertiesFormat.new
          subnet_properties.address_prefix = ['10.1.0.0/24']
          subnet = Azure::ARM::Network::Models::Subnet.new
          subnet.name = 'fog-test-subnet'
          subnet.properties = subnet_properties
          address_space = Azure::ARM::Network::Models::AddressSpace.new
          address_space.address_prefixes = ['10.2.0.0/16']
          dhcp_options = Azure::ARM::Network::Models::DhcpOptions.new
          dhcp_options.dns_servers = ['10.1.0.0/16,10.2.0.0/16']
          virtual_network_properties = Azure::ARM::Network::Models::VirtualNetworkPropertiesFormat.new
          virtual_network_properties.address_space = address_space
          virtual_network_properties.dhcp_options = dhcp_options
          virtual_network_properties.subnets = [subnet]
          virtual_network = Azure::ARM::Network::Models::VirtualNetwork.new
          virtual_network.name = 'fog-test-virtual-network'
          virtual_network.id = '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Network/virtualNetworks/fog-test-virtual-network'
          virtual_network.location = 'West US'
          virtual_network.properties = virtual_network_properties

          virtual_network
        end

        def self.list_virtual_networks_response
          body = '{
            "value": [ { 
              "name":" myvnet1",
              "id":"/subscriptions/{guid}/resourceGroups/mygroup1/providers/Microsoft.Network/virtualNetworks/myvnet1",
              "location":"North US",
              "tags":{ 
                "key":"value"
              },
              "etag":"W/\"00000000-0000-0000-0000-000000000000\"",
              "properties":{
                "resourceGuid":"FA0F0F1A-158F-4725-ACCE-C7B6D5CD937F", 
                "provisioningState":"Succeeded",
                "addressSpace":{ 
                  "addressPrefixes":[ 
                    "10.1.0.0/16",
                    "10.2.0.0/16"
                  ]
                },
                "dhcpOptions":{ 
                  "dnsServers":[ 
                    "10.1.0.5",
                    "10.1.0.6"
                  ]
                },
                "subnets":[ 
                  { 
                    "name":"mysubnet1",
                    "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/myvnet1/subnets/mysubnet1",
                    "etag":"W/\"00000000-0000-0000-0000-000000000000\"",
                    "properties":{ 
                      "provisioningState":"Succeeded",
                      "addressPrefix":"10.1.0.0/24",
                      "networkSecurityGroup":{ 
                        "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/myNSG1"
                      },
                      "ipConfigurations":[ 
                        { 
                          "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/vm1nic1/ipConfigurations/ip1"
                        },
                        { 
                          "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/lb1/frontendIpConfigurations/ip1"
                        },
                        { 
                          "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/vpnGateways/gw1/ipConfigurations/ip1"
                        }
                      ]
                    }
                  }
                ]
              } 
            } ]
          }'
          result = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
          result.body = Azure::ARM::Network::Models::VirtualNetworkListResult.deserialize_object(JSON.load(body))
          result
        end

        def self.delete_virtual_network_response
          MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
        end
      end
    end
  end
end
