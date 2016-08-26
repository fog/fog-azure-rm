module ApiStub
  module Models
    module Resources
      # Mock class for Tag Model
      class Resource
        def self.create_response_response
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
          JSON.load(body)
        end

        def self.list_resources_response(client)
          resources = '{
            "value": [{
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
            }]
          }'
          result_mapper = Azure::ARM::Resources::Models::ResourceListResult.mapper
          client.deserialize(result_mapper, JSON.load(resources), 'result.body').value
        end
      end
    end
  end
end
