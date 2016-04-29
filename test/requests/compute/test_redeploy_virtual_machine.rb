require File.expand_path '../../test_helper', __dir__

# Test class for Redeploy Virtual Machine Request
class TestRedeployVirtualMachine < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@compute_mgmt_client)
    @virtual_machines = client.virtual_machines
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_redeploy_virtual_machine_success
    response = ApiStub::Requests::Compute::VirtualMachine.deallocate_virtual_machine_response
    @promise.stub :value!, response do
      @virtual_machines.stub :redeploy, @promise do
        assert_equal @service.redeploy_virtual_machine('fog-test-rg', 'fog-test-server'), response
      end
    end
  end

  def test_redeploy_virtual_machine_failure
    response = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @virtual_machines.stub :redeploy, @promise do
        assert_raises(RuntimeError) { @service.redeploy_virtual_machine('fog-test-rg', 'fog-test-server') }
      end
    end
  end
end
