require File.expand_path '../../test_helper', __dir__

# Test class for Create Availability Set Request
class TestGetVirtualMachine < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@compute_mgmt_client)
    @virtual_machines = client.virtual_machines
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_get_virtual_machine_success
    response = ApiStub::Requests::Compute::VirtualMachine.create_virtual_machine_response
    @promise.stub :value!, response do
      @virtual_machines.stub :get, @promise do
        assert_equal @service.get_virtual_machine('fog-test-rg', 'fog-test-server'), response.body
      end
    end
  end

  def test_get_virtual_machine_failure
    response = -> { fail MsRestAzure::AzureOperationError }
    @promise.stub :value!, response do
      @virtual_machines.stub :get, @promise do
        assert_raises(ArgumentError) { @service.get_virtual_machine('fog-test-rg', 'fog-test-server') }
      end
    end
  end
end
