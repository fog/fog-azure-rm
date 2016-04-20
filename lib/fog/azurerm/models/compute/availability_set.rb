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
          Fog::Logger.debug "Creating Availability Set
                       '#{name}' in #{location} region."
          service.create_availability_set(resource_group,
                                          name,
                                          location)
          Fog::Logger.debug "Availability Set #{name} created successfully."
        end

        def destroy
          Fog::Logger.debug "Deleting Availability Set: #{name}."
          service.delete_availability_set(resource_group, name)
          Fog::Logger.debug "Availability Set #{name} deleted successfully."
        end
      end
    end
  end
end
