require File.expand_path '../../test_helper', __dir__

# Test class for Redeploy Virtual Machine Request
class TestRedeployVirtualMachine < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    compute_client = @service.instance_variable_get(:@compute_mgmt_client)
    @virtual_machines = compute_client.virtual_machines
  end

  def test_redeploy_virtual_machine_success
    @virtual_machines.stub :redeploy, true do
      assert @service.redeploy_virtual_machine('fog-test-rg', 'fog-test-server', false)
    end

    async_response = Concurrent::Promise.execute { 10 }
    @virtual_machines.stub :redeploy_async, async_response do
      assert @service.redeploy_virtual_machine('fog-test-rg', 'fog-test-server', true), async_response
    end
  end

  def test_redeploy_virtual_machine_failure
    response = proc { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @virtual_machines.stub :redeploy, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.redeploy_virtual_machine('fog-test-rg', 'fog-test-server', false) }
    end

    async_response = Concurrent::Promise.execute { 10 }
    @virtual_machines.stub :redeploy_async, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.redeploy_virtual_machine('fog-test-rg', 'fog-test-server', true) }
    end
  end
end
