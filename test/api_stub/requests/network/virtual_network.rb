module ApiStub
  module Requests
    module Network
      class VirtualNetwork
        def self.create_virtual_network_response
          body = '{
             "name":" fog-test-virtual-network",
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
          result = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
          result.body = Azure::ARM::Network::Models::VirtualNetwork.deserialize_object(JSON.load(body))
          result
        end

        def self.list_virtual_networks_response
          body = '
            {
              "value": [ {
              "name":" myvnet1",
              "id":"/subscriptions/{guid}/resourceGroups/mygroup1/providers/Microsoft.Network/virtualNetworks/myvnet1",
              "location":"North US",
              "tags":
                {
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
