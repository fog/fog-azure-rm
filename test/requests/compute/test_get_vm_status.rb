require File.expand_path '../../test_helper', __dir__

# Test class for Get Virtual Machine Request
class TestGetVirtualMachineStatus < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @compute_client = @service.instance_variable_get(:@compute_mgmt_client)
    @virtual_machines = @compute_client.virtual_machines
  end

  def test_vm_status_success
    response = ApiStub::Requests::Compute::VirtualMachine.virtual_machine_instance_view_response(@compute_client)
    compare_result = ApiStub::Requests::Compute::VirtualMachine.vm_status_response
    @virtual_machines.stub :get, response do
      assert_equal @service.check_vm_status('fog-test-rg', 'fog-test-server'), compare_result
    end
  end

  def test_vm_status_failure
    response = proc { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @virtual_machines.stub :get, response do
      assert_raises(RuntimeError) { @service.check_vm_status('fog-test-rg', 'fog-test-server') }
    end
  end
end
