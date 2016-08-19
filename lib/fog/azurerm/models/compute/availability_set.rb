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

        def self.parse(avail_set)
          hash = {}
          hash['id'] = avail_set.id
          hash['name'] = avail_set.name
          hash['type'] = avail_set.type
          hash['location'] = avail_set.location
          hash['resource_group'] = get_resource_group_from_id(avail_set.id)
          hash['platform_update_domain_count'] = avail_set.platform_update_domain_count
          hash['platform_fault_domain_count'] = avail_set.platform_fault_domain_count
          hash
        end

        def save
          requires :name
          requires :location
          requires :resource_group
          # need to create the availability set
          as = service.create_availability_set(resource_group, name, location)
          hash = Fog::Compute::AzureRM::AvailabilitySet.parse(as)
          merge_attributes(hash)
        end

        def destroy
          service.delete_availability_set(resource_group, name)
        end
      end
    end
  end
end
