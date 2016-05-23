module Fog
  module Resources
    class AzureRM
      class Real
        def list_resource_groups
          begin
            promise = @rmc.resource_groups.list
            result = promise.value!
            result.body.next_link = ''
            value = Azure::ARM::Resources::Models::ResourceGroupListResult.serialize_object(result.body)['value']
            puts "Result: #{value}"
            value
          rescue  MsRestAzure::AzureOperationError => e
            msg = "Exception listing Resource Groups. #{e.body['error']['message']}"
            raise msg
          end
        end
      end

      class Mock
        def list_resource_groups
          [
            {
              "location"=>"westus",
              "id"=>"/subscriptions/########-####-####-####-############/resourceGroups/Fog_test_rg",
              "name"=>"Fog_test_rg",
              "properties"=>
                {
                  "provisioningState"=>"Succeeded"
                }
            },
            {
                "location"=>"westus",
                "id"=>"/subscriptions/########-####-####-####-############/resourceGroups/Fog_test_rg1",
                "name"=>"Fog_test_rg1",
                "properties"=>
                    {
                        "provisioningState"=>"Succeeded"
                    }
            }
          ]
        end
      end
    end
  end
end
