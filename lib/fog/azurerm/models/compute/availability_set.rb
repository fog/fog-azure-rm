# rubocop:disable MethodLength
# rubocop:disable AbcSize
module Fog
  module Compute
    class AzureRM
      # This class is giving implementation of create/save and
      # delete/destroy for Availability Set.
      class AvailabilitySet < Fog::Model
        identity  :name
        attribute :location
        attribute :resource_group

        def save
          requires :name
          requires :location
          requires :resource_group
          begin
            reponse_of_get_as = service.get_availability_set(resource_group,
                                                             name)
            unless reponse_of_get_as.nil?
              puts "Availability Set #{name} already exists"
              return
            end
          rescue
            # need to create the availability set
            puts "Creating Availability Set
                        '#{name}' in #{location} region."
            avail_set = get_avail_set_properties(location)
            begin
              start_time = Time.now.to_i
              response =
                service.create_availability_set(resource_group,
                                                name,
                                                avail_set).value!
              response.body
              end_time = Time.now.to_i
              duration = end_time - start_time
              puts "Availability Set created in #{duration} seconds"
            rescue MsRestAzure::AzureOperationError => e
              puts("***FAULT:FATAL=#{e.body.values[0]['message']}")
              e = Exception.new('no backtrace')
              e.set_backtrace('')
              raise e
            rescue => ex
              puts "***FAULT:FATAL=#{ex.message}"
              ex = Exception.new('no backtrace')
              ex.set_backtrace('')
              raise ex
            end
          end
        end

        def destroy
          puts "Deleting Availability Set: #{name}."
          service.delete_availability_set(resource_group, name)
          puts "Availability Set #{name} deleted successfully."
        end

        # create the properties object for creating availability sets
        def get_avail_set_properties(location)
          avail_set_props =
            Azure::ARM::Compute::Models::AvailabilitySetProperties.new
          # At least two domain faults
          avail_set_props.platform_fault_domain_count = 2
          avail_set_props.platform_update_domain_count = 2
          # At this point we do not have virtual machines to include
          avail_set_props.virtual_machines = []
          avail_set_props.statuses = []
          avail_set = Azure::ARM::Compute::Models::AvailabilitySet.new
          avail_set.location = location
          avail_set.properties = avail_set_props
          avail_set
        end
      end
    end
  end
end
