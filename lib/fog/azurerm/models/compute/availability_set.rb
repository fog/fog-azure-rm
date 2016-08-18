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

        def self.parse(as)
          hash = {}
          if as.is_a? Hash
            hash['id'] = as['id']
            hash['name'] = as['name']
            hash['type'] = as['type']
            hash['location'] = as['location']
            hash['resource_group'] = as['id'].split('/')[4]
            hash['platform_update_domain_count'] = as['platform_update_domain_count']
            hash['platform_fault_domain_count'] = as['platform_fault_domain_count']
          else
            hash['id'] = as.id
            hash['name'] = as.name
            hash['type'] = as.type
            hash['location'] = as.location
            hash['resource_group'] = as.id.split('/')[4]
            hash['platform_update_domain_count'] = as.platform_update_domain_count
            hash['platform_fault_domain_count'] = as.platform_fault_domain_count
          end
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
