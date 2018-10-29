require File.expand_path '../../test_helper', __dir__
# Test class for List VirtualMachineSizes#

class TestListVirtualMachineSizes < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@compute_mgmt_client)
    @virtual_machine_sizes = @client.virtual_machine_sizes
  end

  def test_list_virtual_machine_sizes_success
    mocked_response = ApiStub::Requests::Compute::VirtualMachineSize.list_response(@client)
    @virtual_machine_sizes.stub :list, mocked_response do
      assert_equal mocked_response.value, @service.list_virtual_machine_sizes('location')
    end

    async_response = Concurrent::Promise.execute { 10 }
    @virtual_machine_sizes.stub :list, async_response do
      assert @service.list_virtual_machine_sizes('location', true)
    end
  end

  def test_list_virtual_machine_sizes_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @virtual_machine_sizes.stub :list, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.list_virtual_machine_sizes('location') }
    end
  end
end
