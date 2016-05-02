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
        attribute :tags
        attribute :resource_group
        attribute :properties

        def save
          requires :name
          requires :location
          requires :resource_group
          # need to create the availability set
          service.create_availability_set(resource_group, name, location)
        end

        def destroy
          service.delete_availability_set(resource_group, name)
        end
      end
    end
  end
end
