require 'fog/core/collection'
require 'fog/azurerm/models/compute/availability_set'
# rubocop:disable LineLength
# rubocop:disable MethodLength
# rubocop:disable AbcSize
module Fog
  module Compute
    class AzureRM
      # This class is giving implementation of all/list, get and
      # check name availability for storage account.
      class AvailabilitySets < Fog::Collection
        model Fog::Compute::AzureRM::AvailabilitySet
        attribute :resource_group_name
        def all
          accounts = []
            requires :resource_group_name
            hash_of_storage_accounts = service.list_availability_sets(resource_group_name)
            hash_of_storage_accounts.each do |account|
            hash = {}
            account.instance_variables.each do |var|
              hash[var.to_s.delete('@')] = account.instance_variable_get(var)
            end
            accounts << hash
          end
          load(accounts)
        end

        def get(resource_group, identity)
          response = service.get_availability_set(resource_group, identity)
          response.body
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
