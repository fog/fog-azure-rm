require 'fog/core/collection'
require 'fog/azurerm/models/compute/availability_set'
# rubocop:disable MethodLength
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
              puts "Account: #{account.inspect}"
              parse_response = Fog::Compute::AzureRM::AvailabilitySet.parse(account)
              accounts << parse_response
              puts "Account: #{accounts}"
            end
          end
          load(accounts)
        end

        def get(resource_group, identity)
          all.find { |as| as.resource_group == resource_group && as.name == identity }
        end
      end
    end
  end
end
