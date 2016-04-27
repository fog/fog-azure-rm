require File.expand_path '../../test_helper', __dir__

# Test class for Create Availability Set Request
class TestDeallocateVirtualMachine < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@compute_mgmt_client)
    @virtual_machines = client.virtual_machines
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_deallocate_virtual_machine_success
    response = ApiStub::Requests::Compute::VirtualMachine.deallocate_virtual_machine_response
    @promise.stub :value!, response do
      @virtual_machines.stub :deallocate, @promise do
        assert_equal @service.deallocate_virtual_machine('fog-test-rg', 'fog-test-server'), response
      end
    end
  end

  def test_deallocate_virtual_machine_failure
    response = -> { fail MsRestAzure::AzureOperationError }
    @promise.stub :value!, response do
      @virtual_machines.stub :deallocate, @promise do
        assert_raises(ArgumentError) { @service.deallocate_virtual_machine('fog-test-rg', 'fog-test-server') }
      end
    end
  end
end
