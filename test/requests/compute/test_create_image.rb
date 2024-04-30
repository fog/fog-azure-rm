require File.expand_path('../../test_helper', __dir__)

# Test class for Create Image Request
class TestCreateImage < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    compute_client = @service.instance_variable_get(:@compute_mgmt_client)
    @image = compute_client.images
    @response = ApiStub::Requests::Compute::Image.create_image(compute_client)
    @input_params = ApiStub::Requests::Compute::Image.image_params
  end

  def test_create_image_success
    @image.stub :create_or_update, @response do
      assert_equal @service.create_image(@input_params), @response
    end
  end

  def test_create_image_from_vm_success
    input_params = ApiStub::Requests::Compute::Image.image_params_from_virtual_machine
    @image.stub :create_or_update, @response do
      assert_equal @service.create_image(input_params), @response
    end
  end

  def test_create_image_from_managed_disk_success
    input_params = ApiStub::Requests::Compute::Image.image_params_from_managed_disk
    @image.stub :create_or_update, @response do
      assert_equal @service.create_image(input_params), @response
    end
  end

  def test_create_image_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @image.stub :create_or_update, response do
      assert_raises MsRestAzure::AzureOperationError do
        @service.create_image(@input_params)
      end
    end
  end
end
