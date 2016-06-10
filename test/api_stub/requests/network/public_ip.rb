module ApiStub
  module Requests
  	module Network
  	  class PublicIp
  	  	def self.create_public_ip_response
          body = '{
             "name": "fog-test-public-ip",
             "id": "/subscriptions/{guid}/resourceGroups/fog-test-rg/Microsoft.Network/publicIpAddresses/fog-test-public-ip",
             "location": "West US",
             "tags": {
                "key": "value"
             },
             "etag": "W/\"00000000-0000-0000-0000-000000000000\"",
             "properties": {
                "resourceGuid":"0CB6BF8A-FFBD-486A-A6A2-DA6633481B50",
                "provisioning_state": "Succeeded",
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
          result = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
          result.body = Azure::ARM::Network::Models::PublicIPAddress.deserialize_object(JSON.load(body))
          result
  	  	end

        def self.list_public_ips_response
          body = '{
            "value": [ {
              "name": "myPublicIP1",
              "id": "/subscriptions/{guid}/resourceGroups/rg1/Microsoft.Network/publicIpAddresses/ip1",
              "location": "North US",
              "tags": {
                 "key": "value"
              },
              "etag": "W/\"00000000-0000-0000-0000-000000000000\"",
              "properties": {
                "resourceGuid":"0CB6BF8A-FFBD-486A-A6A2-DA6633481B50",
                "provisioning_state": "Succeeded",
                "ipAddress": "1.1.1.1",
                "publicIPAllocationMethod": "Static",
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
            } ]
          }'
          result = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
          result.body = Azure::ARM::Network::Models::PublicIPAddressListResult.deserialize_object(JSON.load(body))
          result
        end

        def self.delete_public_ip_response
          MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
        end
  	  end
  	end
  end
end