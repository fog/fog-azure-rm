module ApiStub
  module Models
    module Network
      class NetworkInterface
        def self.create_network_interface_response(network_client)
          nic = '{
             "name":"fog-test-network-interface",
             "id":"/subscriptions/{guid}/resourceGroups/fog-test-rg/providers/Microsoft.Network/networkInterfaces/fog-test-network-interface",
             "location":"West US",
             "tags":{
                "key":"value"
             },
             "etag":"W/\"00000000-0000-0000-0000-000000000000\"",
             "properties":{
                "resourceGuid":"5ED47B81-9F1C-4ACE-97A5-7B8CE08C5002",
                "provisioningState":"Succeeded",
                "virtualMachine":{
                   "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Compute/virtualMachines/vm1"
                },
                "macAddress":"00-00-00-00-00-00",
                "networkSecurityGroup":{
                   "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/myNSG1"
                },
                "ipConfigurations":[
                   {
                      "name":"myip1",
                      "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/vm1mynic1/ipConfigurations/myip1",
                      "etag":"W/\"00000000-0000-0000-0000-000000000000\"",
                      "properties":{
                         "provisioningState":"Succeeded",
                         "subnet":{
                            "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/myvnet1/subnets/mysub1"
                         },
                         "privateIPAddress":"10.0.0.8",
                         "privateIPAllocationMethod":"Static",
                         "publicIPAddress":{
                            "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/publicIPAddresses/mypip1"
                         },
                         "loadBalancerBackendAddressPools":[
                            {
                               "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/mylb1/backendAddressPools/pool1"
                            }
                         ],
                         "loadBalancerInboundNatRules":[
                            {
                               "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/mylb1/inboundNatRules/rdp for myvm1"
                            },
                            {
                               "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/mylb1/inboundNatRules/powershell for myvm1"
                            }
                         ]
                      }
                   }
                ],
                "dnsSettings":{
                   "dnsServers":[
                      "10.0.0.4",
                      "10.0.0.5"
                   ],
                   "appliedDnsServers": ["1.0.0.1", "2.0.0.2", "3.0.0.3"],
                   "internalDnsNameLabel": "IdnsVm1",
                   "internalFqd": "IdnsVm1.a2ftlxfjn2iezihj3udx1wfn4d.hx.internal.cloudapp.net"
                }
             }
          }'
          network_interface_mapper = Azure::ARM::Network::Models::NetworkInterface.mapper
          network_client.deserialize(network_interface_mapper, JSON.load(nic), 'result.body')
        end
      end
    end
  end
end
