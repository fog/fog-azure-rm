require File.expand_path '../../test_helper', __dir__

# Test class for List Available Sizes For VirtualMachine Request
class TestListAvailableSizesForVirtualMachine < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@compute_mgmt_client)
    @virtual_machines = client.virtual_machines
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_list_available_sizes_for_virtual_machine_success
    response = ApiStub::Requests::Compute::VirtualMachine.list_available_sizes_for_virtual_machine_response
    compare_value = Azure::ARM::Compute::Models::VirtualMachineSizeListResult.serialize_object(response.body)['value']
    @promise.stub :value!, response do
      @virtual_machines.stub :list_available_sizes, @promise do
        assert_equal compare_value, @service.list_available_sizes_for_virtual_machine('fog-test-rg', 'fog-test-server')
      end
    end
  end

  def test_list_available_sizes_for_virtual_machine_failure
    response = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @virtual_machines.stub :list_available_sizes, @promise do
        assert_raises(RuntimeError) { @service.list_available_sizes_for_virtual_machine('fog-test-rg', 'fog-test-server') }
      end
    end
  end
end
