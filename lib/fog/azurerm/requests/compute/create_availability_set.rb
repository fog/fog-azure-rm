# rubocop:disable AbcSize
# rubocop:disable MethodLength
module Fog
  module Compute
    class AzureRM
      # This class provides the actual implemention for service calls.
      class Real
        def create_availability_set(resource_group, name, params)
          begin
            response = @compute_mgmt_client.availability_sets
                                           .create_or_update(resource_group,
                                                             name,
                                                             params).value!
            response.body
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
      # This class provides the mock implementation for unit tests.
      class Mock
        def create_availability_set(resource_group, name, params)
        end
      end
    end
  end
end
