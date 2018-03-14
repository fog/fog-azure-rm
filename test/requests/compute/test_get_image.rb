require File.expand_path('../../test_helper', __dir__)

# Test class for Get Image Request
class TestGetImage < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    compute_client = @service.instance_variable_get(:@compute_mgmt_client)
    @image = compute_client.images
  end

  def test_get_image_success
    @image.stub :get, true do
      assert @service.get_image('fog-test-rg', 'TestImage')
    end
  end

  def test_get_image_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @image.stub :get, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.get_image('fog-test-rg', 'TestImage') }
    end
  end
end
