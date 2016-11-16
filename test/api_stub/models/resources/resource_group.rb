module ApiStub
  module Models
    module Resources
      # Mock class for Resource Group Model
      class ResourceGroup
        def self.create_resource_group_response(client)
          resource_group = '{
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
          result_mapper = Azure::ARM::Resources::Models::ResourceGroup.mapper
          client.deserialize(result_mapper, Fog::JSON.decode(resource_group), 'result.body')
        end
      end
    end
  end
end
