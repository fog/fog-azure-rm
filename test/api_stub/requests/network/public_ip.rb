module ApiStub
  module Requests
  	module Network
  	  class PublicIp
  	  	def self.create_public_ip_response
  	  	  public_ip = Azure::ARM::Network::Models::PublicIPAddress.new
          public_ip.name = 'fog-test-public-ip'
          public_ip.location = 'West US'
          public_ip.properties = Azure::ARM::Network::Models::PublicIPAddressPropertiesFormat.new
          public_ip.properties.public_ipallocation_method = 'Dynamic'

          public_ip
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
                "provisioningState": "Succeeded",         
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