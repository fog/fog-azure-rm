require File.expand_path '../../test_helper', __dir__

# Test class for Create Virtual Machine Request
class TestCreateGeneralizedImage < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    compute_client = @service.instance_variable_get(:@compute_mgmt_client)
    @image = compute_client.images
    @response = ApiStub::Requests::Compute::GeneralizedImage.create_generalized_image(compute_client)
    @input_params = {
      resource_group: 'fog-test-rg',
      vm_name: 'fog-test-server',
      location: 'westus',
      platform: 'Linux',
      new_vhd_path: 'https://mystorageaccount.blob.core.windows.net/osimages/osimage.vhd'
    }
  end

  def test_create_generalized_image_success
    @image.stub :create_or_update, @response do
      assert_equal @service.create_generalized_image(@input_params), @response
    end
  end

  def test_create_generalized_image_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @image.stub :create_or_update, response do
      assert_raises RuntimeError do
        @service.create_generalized_image(@input_params)
      end
    end
  end
end
