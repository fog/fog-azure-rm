require File.expand_path '../../test_helper', __dir__

# Test class for List Available Sizes For VirtualMachine Request
class TestListAvailableSizesForVirtualMachine < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @compute_client = @service.instance_variable_get(:@compute_mgmt_client)
    @virtual_machines = @compute_client.virtual_machines
  end

  def test_list_available_sizes_for_virtual_machine_success
    response = ApiStub::Requests::Compute::VirtualMachine.list_available_sizes_for_virtual_machine_response(@compute_client)
    @virtual_machines.stub :list_available_sizes, response do
      assert_equal @service.list_available_sizes_for_virtual_machine('fog-test-rg', 'fog-test-server'), response.value
    end
  end

  def test_list_available_sizes_for_virtual_machine_failure
    response = proc { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @virtual_machines.stub :list_available_sizes, response do
      assert_raises(RuntimeError) { @service.list_available_sizes_for_virtual_machine('fog-test-rg', 'fog-test-server') }
    end
  end
end
