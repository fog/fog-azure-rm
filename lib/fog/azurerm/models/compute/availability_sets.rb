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
              hash = {}
              account.instance_variables.each do |var|
                hash[var.to_s.delete('@')] = account.instance_variable_get(var)
              end
              hash['resource_group'] = resource_group
              accounts << hash
            end
          end
          load(accounts)
        end

        def get(resource_group, identity)
          all.find { |as| as.resource_group == resource_group && as.name == identity }
          #service.get_availability_set(resource_group, identity)
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
