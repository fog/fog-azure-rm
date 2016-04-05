module Fog
  module Network
    class AzureRM
      class Real
        def check_for_public_ip(resource_group, name)
          begin
            promise = @network_client.public_ipaddresses.get(resource_group, name)
            response = promise.value!
            result = response.body
            return true
          rescue  MsRestAzure::AzureOperationError =>e
            puts "Azure::PublicIp - Exception is: #{e.body}"
            if(error_response["code"] == "ResourceNotFound")
              return false
            else
              return true
            end
          rescue Exception => e
            msg = "Exception trying to get public ip #{public_ip_name} from resource group: #{resource_group_name}"
            fail msg
          end
        end
      end

      class Mock

      end
    end
  end
end