module Fog
  module Resources
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def create_resource_group(name, location, tags)
          msg = "Creating Resource Group: #{name}."
          Fog::Logger.debug msg

          body = create_resource_group_body(location, tags).to_json

          url = "subscriptions/#{@subscription_id}/resourcegroups/#{name}?api-version=2017-05-10"
          begin
            response = Fog::AzureRM::NetworkAdapter.put(
              url,
              @token,
              body
            )
          rescue => e
            raise e
          end

          response_status = parse_response(response)

          if response_status.eql?(SUCCESS)
            Fog::Logger.debug "Resource Group #{name} created successfully."
            response.env.body
          else
            raise Fog::AzureRM::CustomException(response)
          end
        end

        def create_resource_group_body(location, tags)
          parameters = {
            location: location,
            properties: {}
          }
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def create_resource_group(name, location)
          resource_group = {
            'location' => location,
            'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{name}",
            'name' => name,
            'properties' =>
            {
              'provisioningState' => 'Succeeded'
            }
          }
          result_mapper = Azure::ARM::Resources::Models::ResourceGroup.mapper
          @rmc.deserialize(result_mapper, resource_group, 'result.body')
        end
      end
    end
  end
end
