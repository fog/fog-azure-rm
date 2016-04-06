module Fog
  module Network
    class AzureRM
      # Real class for Network Request
      class Real
        def list_public_ips(resource_group)
          puts "Getting list of PublicIPs from Resource Group #{resource_group}."
          begin
            promise = @network_client.public_ipaddresses.list(resource_group)
            response = promise.value!
            result = response.body.value
            return result
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Error Getting list of PublicIPs from ResourceGroup '#{resource_group}'. #{e.body}."
            fail msg
          end
        end
      end

      # Mock class for Network Request
      class Mock
        def list_public_ips(_resource_group)
          public_ip = Azure::ARM::Network::Models::PublicIPAddress.new
          public_ip.name = 'fogtestpublicip'
          public_ip.location = 'West US'
          public_ip.type = 'Static'
          [public_ip]
        end
      end
    end
  end
end
