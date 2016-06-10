module ApiStub
  module Models
    module Network
      class Subnet
        def self.create_subnet_response
          subnet = '{
             "name":"fog-test-subnet",
             "id":"/subscriptions/{guid}/resourceGroups/fog-test-rg/providers/Microsoft.Network/virtualNetworks/vnet1/subnets/fog-test-subnet",
             "etag":"W/\"00000000-0000-0000-0000-000000000000\"",
             "properties":{
                "provisioning_state":"Succeeded",
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
          }'
          JSON.parse(subnet)
        end
      end
    end
  end
end
