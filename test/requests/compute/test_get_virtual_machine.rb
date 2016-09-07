require File.expand_path '../../../test_helper', __FILE__

# Test class for Get Virtual Machine Request
class TestGetVirtualMachine < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @compute_client = @service.instance_variable_get(:@compute_mgmt_client)
    @virtual_machines = @compute_client.virtual_machines
  end

  def test_get_virtual_machine_success
    response = ApiStub::Requests::Compute::VirtualMachine.create_virtual_machine_response(@compute_client)
    @virtual_machines.stub :get, response do
      assert_equal @service.get_virtual_machine('fog-test-rg', 'fog-test-server'), response
    end
  end

  def test_get_virtual_machine_failure
    response = proc { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @virtual_machines.stub :get, response do
      assert_raises(RuntimeError) { @service.get_virtual_machine('fog-test-rg', 'fog-test-server') }
    end
  end
end
