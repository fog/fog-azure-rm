require File.expand_path '../../test_helper', __dir__
# Test class for List Images
class TestListVirtualMachineSizes < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@compute_mgmt_client)
    @images = @client.images
  end

  def test_list_images_success
    mocked_response = ApiStub::Requests::Compute::Image.list_response(@client)
    @images.stub :list_by_resource_group, mocked_response do
      assert_equal mocked_response, @service.list_images('fog-test-rg')
    end
    async_response = Concurrent::Promise.execute { 10 }
    @images.stub :list_by_resource_group_async, async_response do
      assert_equal async_response, @service.list_images('fog-test-rg', true)
    end
  end

  def test_list_images_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @images.stub :list_by_resource_group, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.list_images('fog-test-rg') }
    end
  end
end
