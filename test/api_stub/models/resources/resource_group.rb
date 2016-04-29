module ApiStub
  module Models
    module Resources
      # Mock class for Resource Group Model
      class ResourceGroup
        def self.create_resource_group_response
          MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
        end

        def self.list_resource_groups_response
          body = '{
            "id": "/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg",
            "name": "fog-test-rg",
            "location": "westus",
            "tags": {
              "tagname1": "tagvalue1"
            },
            "properties": {
              "provisioningState": "Succeeded"
            }
          }'
          Azure::ARM::Resources::Models::ResourceGroup.deserialize_object(JSON.load(body))
        end
      end
    end
  end
end
