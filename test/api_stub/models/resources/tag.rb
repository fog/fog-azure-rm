module ApiStub
  module Models
    module Resources
      # Mock class for Tag Model
      class Tag
        def self.create_tag_response
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

        def self.list_tags_response
          body = '[{
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
          }]'
          JSON.load(body)
        end
      end
    end
  end
end
