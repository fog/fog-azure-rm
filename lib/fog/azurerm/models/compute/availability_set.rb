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
        attribute :is_managed
        attribute :sku_name

        def self.parse(availability_set)
          hash = {}
          hash['id'] = availability_set.id
          hash['name'] = availability_set.name
          hash['type'] = availability_set.type
          hash['location'] = availability_set.location
          hash['resource_group'] = get_resource_group_from_id(availability_set.id)
          hash['platform_update_domain_count'] = availability_set.platform_update_domain_count
          hash['platform_fault_domain_count'] = availability_set.platform_fault_domain_count

          unless availability_set.sku.nil?
            hash['sku_name'] = availability_set.sku.name
            hash['is_managed'] = availability_set.sku.name.eql?(AS_SKU_ALIGNED)
          end

          hash
        end

        def save
          requires :name
          requires :location
          requires :resource_group
          # need to create the availability set
          as = service.create_availability_set(avail_set_params(platform_fault_domain_count, platform_update_domain_count, is_managed))
          hash = Fog::Compute::AzureRM::AvailabilitySet.parse(as)
          merge_attributes(hash)
        end

        def destroy
          service.delete_availability_set(resource_group, name)
        end

        private

        def avail_set_params(platform_fault_domain_count, platform_update_domain_count, is_managed)
          {
            name: name,
            location: location,
            resource_group: resource_group,
            platform_fault_domain_count: platform_fault_domain_count,
            platform_update_domain_count: platform_update_domain_count,
            is_managed: is_managed
          }
        end
      end
    end
  end
end
