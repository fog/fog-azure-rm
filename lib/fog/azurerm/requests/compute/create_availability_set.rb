module Fog
  module Compute
    class AzureRM
      # This class provides the actual implementation for service calls.
      class Real
        def create_availability_set(availability_set_params)
          name = availability_set_params[:name]
          location = availability_set_params[:location]
          resource_group = availability_set_params[:resource_group]
          fault_domain_count = availability_set_params[:platform_fault_domain_count]
          update_domain_count = availability_set_params[:platform_update_domain_count]
          is_managed = availability_set_params[:is_managed].nil? ? false : availability_set_params[:is_managed]

          msg = "Creating Availability Set '#{name}' in #{location} region."
          Fog::Logger.debug msg
          avail_set_params = get_availability_set_properties(location, fault_domain_count, update_domain_count, is_managed)

          begin
            availability_set = @compute_mgmt_client.availability_sets.create_or_update(resource_group, name, avail_set_params)
          rescue MsRestAzure::AzureOperationError => e
            raise_azure_exception(e, msg)
          end
          Fog::Logger.debug "Availability Set #{name} created successfully."
          availability_set
        end

        # create the properties object for creating availability sets
        def get_availability_set_properties(location, fault_domain_count, update_domain_count, is_managed)
          avail_set = Azure::ARM::Compute::Models::AvailabilitySet.new
          avail_set.location = location
          avail_set.sku = create_availability_set_sku(is_managed)
          avail_set.platform_fault_domain_count = fault_domain_count.nil? ? FAULT_DOMAIN_COUNT : fault_domain_count
          avail_set.platform_update_domain_count = update_domain_count.nil? ? UPDATE_DOMAIN_COUNT : update_domain_count
          avail_set
        end

        def create_availability_set_sku(is_managed)
          sku = Azure::ARM::Compute::Models::Sku.new
          sku.name = is_managed ? AS_SKU_ALIGNED : AS_SKU_CLASSIC
          sku
        end
      end

      # This class provides the mock implementation for unit tests.
      class Mock
        def create_availability_set(availability_set_params)
          {
            'location' => availability_set_params[:location],
            'id' => "/subscriptions/########-####-####-####-############/resourceGroups/#{availability_set_params[:resource_group]}/providers/Microsoft.Compute/availabilitySets/#{availability_set_params[:name]}",
            'name' => availability_set_params[:name],
            'type' => 'Microsoft.Compute/availabilitySets',
            'properties' =>
            {
              'platformUpdateDomainCount' => FAULT_DOMAIN_COUNT,
              'platformFaultDomainCount' => FAULT_DOMAIN_COUNT
            }
          }
        end
      end
    end
  end
end
