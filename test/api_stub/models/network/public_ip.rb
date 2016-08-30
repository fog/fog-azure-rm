module ApiStub
  module Models
    module Network
      class PublicIp
        def self.create_public_ip_response(network_client)
          public_ip = '{
             "name": "fog-test-public-ip",
             "id": "/subscriptions/{guid}/resourceGroups/fog-test-rg/providers/Microsoft.Network/publicIpAddresses/fog-test-public-ip",
             "location": "West US",
             "tags": {
                "key": "value"
             },
             "etag": "W/\"00000000-0000-0000-0000-000000000000\"",
             "properties": {
                "resourceGuid":"0CB6BF8A-FFBD-486A-A6A2-DA6633481B50",
                "provisioningState": "Succeeded",
                "ipAddress": "1.1.1.1",
                "publicIPAllocationMethod": "Dynamic",
                "idleTimeoutInMinutes": 4,
                "ipConfiguration": {
                   "id": "/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/vm1nic1/ipConfigurations/ip1"
                },
                "dnsSettings": {
                   "domainNameLabel": "mylabel",
                   "fqdn": "mylabel.northus.cloudapp.azure.com.",
                   "reverseFqdn": "contoso.com."
                }
             }
          }'
          public_ip_mapper = Azure::ARM::Network::Models::PublicIPAddress.mapper
          network_client.deserialize(public_ip_mapper, JSON.load(public_ip), 'result.body')
        end

        def self.update_public_ip_response(network_client)
          public_ip = '{
             "name": "fog-test-public-ip",
             "id": "/subscriptions/{guid}/resourceGroups/fog-test-rg/Microsoft.Network/publicIpAddresses/fog-test-public-ip",
             "location": "West US",
             "tags": {
                "key": "value"
             },
             "etag": "W/\"00000000-0000-0000-0000-000000000000\"",
             "properties": {
                "resourceGuid":"0CB6BF8A-FFBD-486A-A6A2-DA6633481B50",
                "provisioningState": "Succeeded",
                "ipAddress": "1.1.1.1",
                "publicIPAllocationMethod": "Dynamic",
                "idleTimeoutInMinutes": 10,
                "ipConfiguration": {
                   "id": "/subscriptions/{guid}/resourceGroups/{resourceGroupName}/providers/Microsoft.Network/networkInterfaces/vm1nic1/ipConfigurations/ip1"
                },
                "dnsSettings": {
                   "domainNameLabel": "mylabel",
                   "fqdn": "mylabel.northus.cloudapp.azure.com.",
                   "reverseFqdn": "contoso.com."
                }
             }
          }'
          public_ip_mapper = Azure::ARM::Network::Models::PublicIPAddress.mapper
          network_client.deserialize(public_ip_mapper, JSON.load(public_ip), 'result.body')
        end
      end
    end
  end
end
