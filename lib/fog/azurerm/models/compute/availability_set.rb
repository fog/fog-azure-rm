# rubocop:disable MethodLength
# rubocop:disable AbcSize
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
        attribute :platformUpdateDomainCount
        attribute :platformFaultDomainCount

        def self.parse(as)
        hash = {}
        hash['id'] = as['id']
        hash['name'] = as['name']
        hash['type'] = as['type']
        hash['location'] = as['location']
        hash['resource_group'] = as['id'].split('/')[4]
        hash['platformUpdateDomainCount'] = as['properties']['platformUpdateDomainCount']
        hash['platformFaultDomainCount'] = as['properties']['platformFaultDomainCount']
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
