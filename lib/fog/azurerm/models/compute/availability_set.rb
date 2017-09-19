module Fog
  module Compute
    class AzureRM
      # This class is giving implementation of create/save and
      # delete/destroy for Availability Set.
      class AvailabilitySet < Fog::Model
        attribute :id
        identity  :name
        attribute :type
        attribute :location
        attribute :resource_group
        attribute :platform_update_domain_count
        attribute :platform_fault_domain_count

        def self.parse(availability_set)
          hash = {}
          hash['id'] = availability_set.id
          hash['name'] = availability_set.name
          hash['type'] = availability_set.type
          hash['location'] = availability_set.location
          hash['resource_group'] = get_resource_group_from_id(availability_set.id)
          hash['platform_update_domain_count'] = availability_set.platform_update_domain_count
          hash['platform_fault_domain_count'] = availability_set.platform_fault_domain_count
          hash
        end

        def save
          requires :name
          requires :location
          requires :resource_group
          # need to create the availability set
          as = service.create_availability_set(availability_set_params(platform_fault_domain_count, platform_update_domain_count))
          hash = Fog::Compute::AzureRM::AvailabilitySet.parse(as)
          merge_attributes(hash)
        end

        def destroy
          service.delete_availability_set(resource_group, name)
        end

        private

        def availability_set_params(platform_fault_domain_count, platform_update_domain_count)
          {
            name: name,
            location: location,
            resource_group: resource_group,
            platform_fault_domain_count: platform_fault_domain_count,
            platform_update_domain_count: platform_update_domain_count
          }
        end
      end
    end
  end
end
