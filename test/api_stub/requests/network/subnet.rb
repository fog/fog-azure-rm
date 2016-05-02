module ApiStub
  module Requests
    module Network
      class Subnet
        def self.create_subnet_response
          subnet = Azure::ARM::Network::Models::Subnet.new
          subnet.id = '/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg/providers/Microsoft.Network/virtualNetworks/fog-test-virtual-network/subnets/fog-test-subnet'
          subnet.name = 'fog-test-subnet'
          subnet.properties = Azure::ARM::Network::Models::SubnetPropertiesFormat.new
          subnet.properties.address_prefix = '10.1.0.0/24'

          subnet
        end

        def self.list_subnets_response
          body = '{
            "value": [ { 
              "name":"mysubnet1",
              "id":"/subscriptions/{guid}/resourceGroups/rg1/providers/Microsoft.Network/virtualNetworks/vnet1/subnets/mysubnet1",
              "etag":"W/\"00000000-0000-0000-0000-000000000000\"",
              "properties":{ 
                "provisioningState":"Succeeded",
                "addressPrefix":"10.1.0.0/24",
                "networkSecurityGroup":{ 
                  "id":"/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkSecurityGroups/myNSG1"
                },
                "routeTable": { "id": "/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/routeTables/myRT1" },
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
            } ]
          }'
          result = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
          result.body = Azure::ARM::Network::Models::SubnetListResult.deserialize_object(JSON.load(body))
          result
        end

        def self.delete_subnet_response
          MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
        end
      end
    end
  end
end
