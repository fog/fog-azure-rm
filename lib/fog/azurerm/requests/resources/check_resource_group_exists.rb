module Fog
  module Resources
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def check_resource_group_exists(resource_group_name)
          msg = "Checking Resource Group #{resource_group_name}"
          Fog::Logger.debug msg

          url = "subscriptions/#{@subscription_id}/resourcegroups/#{resource_group_name}?api-version=2017-05-10"
          
          begin
            response = Fog::AzureRM::NetworkAdapter.get(url, @token)
          rescue => e
            raise e
          end

          response_status = parse_response(response)

          if response_status.eql?(SUCCESS)
            response.env.body
          else
            raise Fog::AzureRM::CustomException(response)
          end
        end
      end
      # This class provides the mock implementation for unit tests.
      class Mock
        def check_resource_group_exists(*)
          true
        end
      end
    end
  end
end
