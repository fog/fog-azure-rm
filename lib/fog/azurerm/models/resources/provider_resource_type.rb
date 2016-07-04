module Fog
  module Resources
    class AzureRM
      # ProviderResourceType model class
      class ProviderResourceType < Fog::Model
        attribute :resource_type
        attribute :locations
        attribute :api_versions
        attribute :properties

        def self.parse(provider_resource_type)
          hash = {}
          hash['resource_type'] = provider_resource_type['resourceType']
          hash['locations'] = provider_resource_type['locations']
          hash['api_versions'] = provider_resource_type['apiVersions'] unless provider_resource_type['apiVersions'].nil?
          hash['properties'] = provider_resource_type['properties'] unless provider_resource_type['properties'].nil?
          hash
        end
      end
    end
  end
end
