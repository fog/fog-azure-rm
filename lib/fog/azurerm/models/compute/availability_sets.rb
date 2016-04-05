require 'fog/core/collection'
require 'fog/azurerm/models/compute/availability_set'
# rubocop:disable LineLength
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
          hash_of_storage_accounts = service.list_availability_sets(resource_group)
          hash_of_storage_accounts.each do |account|
            hash = {}
            account.instance_variables.each do |var|
              hash[var.to_s.delete('@')] = account.instance_variable_get(var)
              hash['resource_group'] = resource_group
            end
            accounts << hash
          end
          load(accounts)
        end

        def get(resource_group, identity)
          #all.find { |f| f.resource_group == resource_group && f.name == identity }
          begin
          response = service.get_availability_set(resource_group, identity)
          puts "Response of get function: #{response}"
          rescue Exception => e
            puts "Not Found #{e}"
          end
        rescue Fog::Errors::NotFound
          nil
        end
      end
    end
  end
end
