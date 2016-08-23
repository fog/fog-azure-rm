module ApiStub
  module Models
    module Network
      class VirtualNetwork
        def self.create_virtual_network_response(network_client)
          vnet = '{
             "name":"fog-test-virtual-network",
             "id":"/subscriptions/{guid}/resourceGroups/fog-test-rg/providers/Microsoft.Network/virtualNetworks/fog-test-virtual-network",
             "location":"West US",
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
          }'
          vnet_mapper = Azure::ARM::Network::Models::VirtualNetwork.mapper
          network_client.deserialize(vnet_mapper, JSON.load(vnet), 'result.body')
        end
      end
    end
  end
end
