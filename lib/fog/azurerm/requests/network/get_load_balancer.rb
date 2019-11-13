module Fog
  module Network
    class AzureRM
      # Real class for Load-Balancer Request
      class Real
        def get_load_balancer(resource_group_name, load_balancer_name)
          msg = "Getting Load-Balancer: #{load_balancer_name} in Resource Group: #{resource_group_name}"
          Fog::Logger.debug msg
          begin
            load_balancer = @network_client.load_balancers.get(resource_group_name, load_balancer_name)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Getting Load Balancer #{load_balancer_name} Successfully."
          load_balancer
        end
      end

      # Mock class for Load-Balancer Request
      class Mock
        def get_load_balancer(*)
          response = '{
            "name":"mylb1",
            "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/mylb1",
            "location":"North US",
            "tags":{
              "key":"value"
            },
            "etag":"W/\"00000000-0000-0000-0000-000000000000\"",
            "properties":{
              "resourceGuid":"6ECBD4C1-0DC1-4D86-9F6E-4A58F83C9023",
              "provisioningState":"Succeeded",
              "frontendIPConfigurations":[
                {
                  "name":"myip1",
                  "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/mylb1/frontendIPConfigurations/myip1",
                  "etag":"W/\"00000000-0000-0000-0000-000000000000\"",
                  "properties":{
                    "provisioningState":"Succeeded",
                    "subnet":{
                      "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/myvnet1/subnets/mysubnet1"
                    },
                    "privateIPAddress":"10.0.0.10",
                    "privateIPAllocationMethod":"Static",
                    "publicIPAddress":{
                      "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/publicIPAddresses/myip1"
                    },
                    "loadBalancingRules":[
                      {
                        "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/myLB1/loadBalancingRules/rule1"
                      }
                    ],
                    "inboundNatRules":[
                      {
                        "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/myLB1/inboundNatRules/rule1"
                      }
                    ]
                  }
                }
              ],
              "backendAddressPools":[
                {
                  "name":"pool1",
                  "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/mylb1/backendAddressPools/pool1",
                  "etag":"W/\"00000000-0000-0000-0000-000000000000\"",
                  "properties":{
                    "provisioningState":"Succeeded",
                    "backendIPConfigurations":[
                      {
                        "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/vm1nic1/ipConfigurations/ip1"
                      }
                    ],
                    "loadBalancingRules":[
                      {
                        "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/myLB1/loadBalancingRules/rule1"
                      }
                    ]
                  }
                }
              ],
              "loadBalancingRules":[
                {
                  "name":"HTTP Traffic",
                  "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/mylb1/loadBalancingRules/rule1",
                  "etag":"W/\"00000000-0000-0000-0000-000000000000\"",
                  "properties":{
                    "provisioningState":"Succeeded",
                    "frontendIPConfiguration":{
                      "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/myLB1/frontendIPConfigurations/ip1"
                    },
                    "backendAddressPool":{
                      "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/myLB1/backendAddressPool/pool1"
                    },
                    "protocol":"Tcp",
                    "frontendPort":80,
                    "backendPort":8080,
                    "probe":{
                      "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/myLB1/probes/probe1"
                    },
                    "enableFloatingIP":true,
                    "idleTimeoutInMinutes":4,
                    "loadDistribution":"Default"
                  }
                }
              ],
              "probes":[
                {
                  "name":"my probe 1",
                  "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/myLB1/probes/my probe 1",
                  "etag":"W/\"00000000-0000-0000-0000-000000000000\"",
                  "properties":{
                    "provisioningState":"Succeeded",
                    "protocol":"Tcp",
                    "port":8080,
                    "requestPath":"myprobeapp1/myprobe1.svc",
                    "intervalInSeconds":5,
                    "numberOfProbes":16,
                    "loadBalancingRules":[
                      {
                        "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/myLB1/loadBalancingRules/rule1"
                      }
                    ]
                  }
                }
              ],
              "inboundNatRules":[
                {
                  "name":"RDP Traffic",
                  "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/myLB1/inboundNatRules/RDP Traffic",
                  "etag":"W/\"00000000-0000-0000-0000-000000000000\"",
                  "properties":{
                    "provisioningState":"Succeeded",
                    "frontendIPConfiguration":{
                      "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/myLB1/frontendIPConfigurations/ip1"
                    },
                    "backendIPConfiguration":{
                      "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/vm1nic1/ipConfigurations/ip1"
                    },
                    "protocol":"Tcp",
                    "frontendPort":3389,
                    "backendPort":3389
                  }
                }
              ],
              "inboundNatPools":[
                {
                  "name": "RDPForVMSS1",
                  "id": "/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers /Microsoft.Network/loadBalancers/myLB1/inboundNatRules/RDPForVMSS1",
                  "etag": "W/\"00000000-0000-0000-0000-000000000000\"",
                  "properties": {
                    "provisioningState": "Updating|Deleting|Failed|Succeeded",
                    "frontendIPConfiguration": {
                      "id": "/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/loadBalancers/myLB1/frontendIPConfigurations/ip1"
                    },
                    "protocol": "Tcp",
                    "frontendPortRangeStart": 50000,
                    "frontendPortRangeEnd": 50500,
                    "backendPort": 3389
                  }
                }
              ]
            }
          }'
          load_balancer_mapper = Azure::Network::Profiles::Latest::Mgmt::Models::LoadBalancer.mapper
          @network_client.deserialize(load_balancer_mapper, JSON.load(response), 'result.body')
        end
      end
    end
  end
end
