require File.expand_path('../../test_helper', __dir__)

# Test class for Delete Image Request
class TestDeleteImage < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    compute_client = @service.instance_variable_get(:@compute_mgmt_client)
    @image = compute_client.images
  end

  def test_delete_image_success
    @image.stub :delete, true do
      assert @service.delete_image('fog-test-rg', 'fog-test-server-osImage')
    end
  end

  def test_delete_image_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @image.stub :delete, response do
      assert_raises(RuntimeError) { @service.delete_image('fog-test-rg', 'fog-test-server-osImage') }
    end
  end
end
