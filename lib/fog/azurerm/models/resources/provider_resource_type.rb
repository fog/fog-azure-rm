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
          hash['resource_type'] = provider_resource_type.resource_type
          hash['locations'] = provider_resource_type.locations
          hash['api_versions'] = provider_resource_type.api_versions if provider_resource_type.respond_to?('api_versions')
          hash['properties'] = provider_resource_type.properties if provider_resource_type.respond_to?('properties')
          hash
        end
      end
    end
  end
end
