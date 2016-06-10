module ApiStub
  module Models
    module Resources
      # Mock class for Resource Group Model
      class ResourceGroup
        def self.create_resource_group_response
          body = '{
            "id": "/subscriptions/########-####-####-####-############/resourceGroups/fog-test-rg",
            "name": "fog-test-rg",
            "location": "westus",
            "tags": {
              "tagname1": "tagvalue1"
            },
            "properties": {
              "provisioning_state": "Succeeded"
            }
          }'
          JSON.load(body)
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
              "provisioning_state": "Succeeded"
            }
          }'
          JSON.load(body)
        end
      end
    end
  end
end
