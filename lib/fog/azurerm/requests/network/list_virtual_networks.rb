module Fog
  module Network
    class AzureRM
      class Real
        def list_virtual_networks
          begin
            response = @network_client.virtual_networks.list_all
            result = response.value!
            Azure::ARM::Network::Models::VirtualNetworkListResult.serialize_object(result.body)['value']
          rescue MsRestAzure::AzureOperationError => e
            msg = "Exception listing Virtual Netwroks: #{e.body['error']['message']}"
            fail msg
          end
        end
      end

      class Mock
        def list_virtual_networks
          [
            {
              name: 'fogtestvnet',
              id: '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-resource-group/providers/Microsoft.Network/virtualNetworks/fogtestvnet',
              location: 'West US',
              properties: {
                addressSpace:{
                  addressPrefixes:[
                    '10.1.0.0/16',
                    '10.2.0.0/16'
                  ]
                },
                dhcpOptions:{
                  dnsServers:[
                    '10.1.0.5',
                    '10.1.0.6'
                  ]
                },
                subnets:[
                  {
                    name: 'mysubnet1',
                    id: '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-resource-group/providers/Microsoft.Network/virtualNetworks/fogtestvnet/subnets/mysubnet1',
                    properties:{
                      addressPrefix: "10.1.0.0/24",
                      networkSecurityGroup:{
                        id: "/subscriptions/########-####-####-####-############/resourceGroups/fog-test-resource-group/providers/Microsoft.Network/networkSecurityGroups/myNSG1"
                      },
                      ipConfigurations:[
                        {
                            id: "/subscriptions/########-####-####-####-############/resourceGroups/fog-test-resource-group/providers/Microsoft.Network/networkInterfaces/vm1nic1/ipConfigurations/ip1"
                        }
                      ]
                    }
                  }
                ]
              }
            }
          ]
        end
      end
    end
  end
end
