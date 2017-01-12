module Fog
  module Compute
    class AzureRM
      # This class is giving implementation of all/list, get and
      # check name availability for storage account.
      class AvailabilitySets < Fog::Collection
        model Fog::Compute::AzureRM::AvailabilitySet
        attribute :resource_group
        def all
          accounts = []
          requires :resource_group
          list_of_availability_sets =
            service.list_availability_sets(resource_group)
          unless list_of_availability_sets.nil?
            list_of_availability_sets.each do |account|
              parse_response = Fog::Compute::AzureRM::AvailabilitySet.parse(account)
              accounts << parse_response
            end
          end
          load(accounts)
        end

        def get(resource_group, identity)
          availability_set = service.get_availability_set(resource_group, identity)
          availability_set_fog = Fog::Compute::AzureRM::AvailabilitySet.new(service: service)
          availability_set_fog.merge_attributes(Fog::Compute::AzureRM::AvailabilitySet.parse(availability_set))
        end

        def check_availability_set_exists(resource_group, name)
          service.check_availability_set_exists(resource_group, name)
        end
      end
    end
  end
end
