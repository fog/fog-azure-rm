require File.expand_path '../../test_helper', __dir__

# Test class for Get Virtual Machine Request
class TestGetVirtualMachineStatus < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@compute_mgmt_client)
    @virtual_machines = client.virtual_machines
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_vm_status_success
    response = ApiStub::Requests::Compute::VirtualMachine.virtual_machine_instance_view_response
    compare_result = ApiStub::Requests::Compute::VirtualMachine.vm_status_response
    @promise.stub :value!, response do
      @virtual_machines.stub :get, @promise do
        assert_equal compare_result, @service.check_vm_status('fog-test-rg', 'fog-test-server')
      end
    end
  end

  def test_vm_status_failure
    response = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @virtual_machines.stub :get, @promise do
        assert_raises(RuntimeError) { @service.check_vm_status('fog-test-rg', 'fog-test-server') }
      end
    end
  end
end
