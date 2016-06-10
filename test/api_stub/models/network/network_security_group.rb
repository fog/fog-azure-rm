module ApiStub
  module Models
    module Network
      # Mock class for Network Security Group Model
      class NetworkSecurityGroup
        def self.create_network_security_group_response
          nsg = '{
             "name":"fog-test-nsg",
             "id":"/subscriptions/#####/resourceGroups/fog-test-rg/providers/Microsoft.Network/networkSecurityGroups/fog-test-nsg",
             "location":"West US",
             "tags":{
                "key":"value"
             },
             "etag":"W/\"00000000-0000-0000-0000-000000000000\"",
             "properties":{
                "resourceGuid":"AF6A2C41-9F74-46B3-9F65-F5286FFEE3DE",
                "provisioningState":"Succeeded",
                "securityRules":[
                   {
                      "name":"myNsRule",
                      "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/myNsg/securityRules/myNsRule",
                      "etag":"W/\"00000000-0000-0000-0000-000000000000\"",
                      "properties":{
                         "provisioningState":"Succeeded",
                         "description":"description-of-this-rule",
                         "protocol": "*",
                         "sourcePortRange":"source-port-range",
                         "destinationPortRange":"destination-port-range",
                         "sourceAddressPrefix":"*",
                         "destinationAddressPrefix":"*",
                         "access":"Allow",
                         "priority":"priority-of-the-rule",
                         "direction":"Inbound"
                      }
                   }
                ],
                "defaultSecurityRules":[
                   {
                      "name":"AllowVnetInBound",
                      "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/myNsg/defaultSecurityRules/AllowVnetInBound",
                      "etag":"W/\"00000000-0000-0000-0000-000000000000\"",
                      "properties":{
                         "provisioningState":"Succeeded",
                         "description":"description-of-this-rule",
                         "protocol": "*",
                         "sourcePortRange":"*",
                         "destinationPortRange":"*",
                         "sourceAddressPrefix":"VirtualNetwork",
                         "destinationAddressPrefix":"VirtualNetwork",
                         "access":"Allow ",
                         "priority":65000,
                         "direction":"Inbound"
                      }
                   }
                ],
                "networkInterfaces":[
                   {
                      "id":"/subscriptions/{guid}/resourceGroups/myrg1/providers/Microsoft.Network/networkInterfaces/vm1nic1 "
                   },
                   {
                      "id":"/subscriptions/{guid}/resourceGroups/myrg1/providers/Microsoft.Network/networkInterfaces/vm1nic2"
                   }
                ],
                "subnets":[
                   {
                      "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/virtualNetworks/myvnet1/subnets/mysubnet1"
                   }
                ]
             }
          }'
          JSON.parse(nsg)
        end
      end
    end
  end
end
