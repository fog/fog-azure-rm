module Fog
  module Resources
    class AzureRM
      # Dependency model class
      class Dependency < Fog::Model
        attribute :id
        attribute :resource_name
        attribute :resource_type
        attribute :depends_on

        def self.parse(dependency)
          hash = {}
          hash['id'] = dependency['id']
          hash['resource_name'] = dependency['resourceName']
          hash['resource_type'] = dependency['resourceType']

          hash['depends_on'] = []
          dependency['dependsOn'].each do |sub_dependency|
            dependency_obj = Fog::Resources::AzureRM::Dependency.new
            hash['depends_on'] << dependency_obj.merge_attributes(Fog::Resources::AzureRM::Dependency.parse(sub_dependency))
          end unless dependency['dependsOn'].nil?
          hash
        end
      end
    end
  end
end
