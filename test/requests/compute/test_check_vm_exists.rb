require File.expand_path '../../test_helper', __dir__

# Test class for Check Virtual Machine Exists Request
class TestCheckVirtualMachineExists < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @compute_client = @service.instance_variable_get(:@compute_mgmt_client)
    @virtual_machines = @compute_client.virtual_machines
  end

  def test_check_vm_exists_success
    response = ApiStub::Requests::Compute::VirtualMachine.create_virtual_machine_response(@compute_client)
    @virtual_machines.stub :get, response do
      assert @service.check_vm_exists?('fog-test-rg', 'fog-test-server')
    end
  end

  def test_check_vm_exists_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceNotFound' }) }
    @virtual_machines.stub :get, response do
      assert !@service.check_vm_exists?('fog-test-rg', 'fog-test-server')
    end
  end

  def test_check_vm_exists_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception', 'code' => 'ResourceGroupNotFound' }) }
    @virtual_machines.stub :get, response do
      assert_raises(RuntimeError) { @service.check_vm_exists?('fog-test-rg', 'fog-test-server') }
    end
  end
end
