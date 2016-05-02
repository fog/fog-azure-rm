module ApiStub
  module Requests
    module Network
      class NetworkInterface
        def self.create_network_interface_response
          subnet = Azure::ARM::Network::Models::Subnet.new
          subnet.id = '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Network/virtualNetworks/fog-test-virtual-network/subnets/fog-test-subnet'
          ip_configs_props = Azure::ARM::Network::Models::NetworkInterfaceIPConfigurationPropertiesFormat.new
          ip_configs_props.private_ipallocation_method = 'fog-test-private-ip-allocation-method'
          ip_configs_props.subnet = subnet
          ip_configs = Azure::ARM::Network::Models::NetworkInterfaceIPConfiguration.new
          ip_configs.name = 'fog-test-ip-configuration'
          ip_configs.properties = ip_configs_props
          nic_props = Azure::ARM::Network::Models::NetworkInterfacePropertiesFormat.new
          nic_props.ip_configurations = [ip_configs]
          network_interface = Azure::ARM::Network::Models::NetworkInterface.new
          network_interface.name = 'fog-test-network-interface'
          network_interface.location = 'West US'
          network_interface.properties = nic_props

          network_interface
        end

        def self.list_network_interfaces_response
          body = '{
            "value": [ {
              "name":"mynic1",
              "id":"/subscriptions/{guid}/resourceGroups/myrg1/providers/Microsoft.Network/networkInterfaces/vm1mynic1",
              "location":"North US",
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
                   "internalFqdn": "IdnsVm1.a2ftlxfjn2iezihj3udx1wfn4d.hx.internal.cloudapp.net"
                }
              }
            } ]
          }'
          result = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
          result.body = Azure::ARM::Network::Models::NetworkInterfaceListResult.deserialize_object(JSON.load(body))
          result
        end

        def self.delete_network_interface_response
          MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
        end
      end
    end
  end
end
