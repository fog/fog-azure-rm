module ApiStub
  module Requests
    module Network
      # Mock class for Network Security Group Requests
      class NetworkSecurityGroup
        def self.create_network_security_group_response
          body = '{
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
                               "priority":100,
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
          result = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
          result.body = Azure::ARM::Network::Models::NetworkSecurityGroup.deserialize_object(JSON.load(body))
          result
        end

        def self.add_security_rules_response
          body = '{
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
                               "priority":100,
                               "direction":"Inbound"
                                }
                            },
                            {
                                "name": "testRule",
                                 "properties":{
                                   "description":"This is a test rule",
                                   "protocol": "tcp",
                                   "sourcePortRange":"22",
                                   "destinationPortRange":"22",
                                   "sourceAddressPrefix":"0.0.0.0/0",
                                   "destinationAddressPrefix":"0.0.0.0/0",
                                   "access":"Allow",
                                   "priority":101,
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
          result = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
          result.body = Azure::ARM::Network::Models::NetworkSecurityGroup.deserialize_object(JSON.load(body))
          result
        end

        def self.list_network_security_group_response
          body = '{
            "value":[
              {
                "name":"fog-test-nsg",
                "id":"/subscriptions/####/resourceGroups/fog-test-rg/providers/Microsoft.Network/networkSecurityGroups/fog-test-nsg",
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
                            "priority":100,
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
             }
            ]
          }'
          result = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
          result.body = Azure::ARM::Network::Models::NetworkSecurityGroupListResult.deserialize_object(JSON.load(body))
          result
        end

        def self.delete_network_security_group_response
          MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
        end
      end
    end
  end
end
