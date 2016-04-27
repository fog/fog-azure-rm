require File.expand_path '../../test_helper', __dir__

# Test class for Create Availability Set Request
class TestListVirtualMachines < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@compute_mgmt_client)
    @virtual_machines = client.virtual_machines
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_list_virtual_machines_success
    response = ApiStub::Requests::Compute::VirtualMachine.list_virtual_machines_response
    @promise.stub :value!, response do
      @virtual_machines.stub :list, @promise do
        assert_equal @service.list_virtual_machines('fog-test-rg'), Azure::ARM::Compute::Models::VirtualMachineListResult.serialize_object(response.body)['value']
      end
    end
  end

  def test_list_virtual_machines_failure
    response = -> { fail MsRestAzure::AzureOperationError }
    @promise.stub :value!, response do
      @virtual_machines.stub :list, @promise do
        assert_raises(ArgumentError) { @service.list_virtual_machines('fog-test-rg') }
      end
    end
  end
end
