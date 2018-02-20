module Fog
  module Resources
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def check_resource_group_exists(resource_group_name)
          msg = "Checking Resource Group #{resource_group_name}"
          Fog::Logger.debug msg

          url = 'https://management.azure.com/subscriptions/'

          connection = Faraday.new(url: url)
          begin
            response = connection.get "#{@subscription_id}/resourcegroups/#{@resource_group_name}?api-version=2017-05-10" do |request|
              request.headers['Content-Type'] = 'application/json'
              request.headers['authorization'] = @token
              request.body = '{}'
            end

            # response = connection.get
            puts response.inspect
            # flag = @rmc.resource_groups.check_existence(resource_group_name)
            # if flag
            #   Fog::Logger.debug "Resource Group #{resource_group_name} exists."
            # else
            #   Fog::Logger.debug "Resource Group #{resource_group_name} doesn't exist."
            # end
            # flag
          # rescue MsRestAzure::AzureOperationError => e
          #   raise_azure_exception(e, msg)
          rescue => e
            raise e
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
