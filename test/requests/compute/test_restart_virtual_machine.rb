require File.expand_path '../../test_helper', __dir__

# Test class for Restart Virtual Machine Request
class TestRestartVirtualMachine < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    compute_client = @service.instance_variable_get(:@compute_mgmt_client)
    @virtual_machines = compute_client.virtual_machines
  end

  def test_restart_virtual_machine_success
    @virtual_machines.stub :restart, true do
      assert @service.restart_virtual_machine('fog-test-rg', 'fog-test-server', false)
    end

    async_response = Concurrent::Promise.execute { 10 }
    @virtual_machines.stub :restart_async, async_response do
      assert @service.restart_virtual_machine('fog-test-rg', 'fog-test-server', true), async_response
    end
  end

  def test_restart_virtual_machine_failure
    response = proc { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @virtual_machines.stub :restart, response do
      assert_raises(RuntimeError) { @service.restart_virtual_machine('fog-test-rg', 'fog-test-server', false) }
    end

    async_response = Concurrent::Promise.execute { 10 }
    @virtual_machines.stub :restart_async, async_response do
      assert_raises RuntimeError { @service.restart_virtual_machine('fog-test-rg', 'fog-test-server', true) }
    end
  end
end
