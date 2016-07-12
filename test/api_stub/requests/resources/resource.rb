module ApiStub
  module Requests
    module Resources
      # Mock class for Tag Requests
      class AzureResource
        def self.azure_resource_response
          body = '{
            "id": "/subscriptions/########-####-####-####-############/resourceGroups/{RESOURCE-GROUP}/providers/Microsoft.Network/{PROVIDER-NAME}/{RESOURCE-NAME}",
            "name": "your-resource-name",
                "type": "providernamespace/resourcetype",
                "location": "westus",
                "tags": {
                "tag_name": "tag_value"
            },
                "plan": {
                "name": "free"
            }
          }'
          result = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
          result.body = Azure::ARM::Resources::Models::GenericResource.deserialize_object(JSON.load(body))
          result
        end

        def self.list_tagged_resources_response
          body = '{
            "value": [ {
              "id": "/subscriptions/########-####-####-####-############/resourceGroups/{RESOURCE-GROUP}/providers/Microsoft.Network/{PROVIDER-NAME}/{RESOURCE-NAME}",
              "name": "your-resource-name",
              "type": "providernamespace/resourcetype",
              "location": "westus",
              "tags": {
              "tag_name": "tag_value"
          },
              "plan": {
              "name": "free"
          }
          } ],
            "nextLink": "https://management.azure.com/subscriptions/########-####-####-####-############/resourcegroups?api-version=2015-01-01&$skiptoken=######"
          }'
          result = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
          result.body = Azure::ARM::Resources::Models::ResourceListResult.deserialize_object(JSON.load(body))
          result
        end
      end
    end
  end
end
