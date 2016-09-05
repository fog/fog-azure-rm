require File.expand_path '../../test_helper', __dir__

# Test class for List Virtual Machines Request
class TestListVirtualMachines < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @compute_client = @service.instance_variable_get(:@compute_mgmt_client)
    @virtual_machines = @compute_client.virtual_machines
  end

  def test_list_virtual_machines_success
    response = ApiStub::Requests::Compute::VirtualMachine.list_virtual_machines_response(@compute_client)
    @virtual_machines.stub :list_as_lazy, response do
      assert_equal @service.list_virtual_machines('fog-test-rg'), response.value
    end
  end

  def test_list_virtual_machines_failure
    response = proc { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @virtual_machines.stub :list_as_lazy, response do
      assert_raises(RuntimeError) { @service.list_virtual_machines('fog-test-rg') }
    end
  end
end
