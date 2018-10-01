require File.expand_path '../../test_helper', __dir__
# Test class for Managed Disk Collection
class TestImages < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @images = Fog::Compute::AzureRM::Images.new(resource_group: 'fog-test-rg', service: @service)
    @client = @service.instance_variable_get(:@compute_mgmt_client)
    @image = ApiStub::Models::Compute::Image.image_response(@client)
  end

  def test_collection_attributes
    assert_respond_to @images, :resource_group
  end

  def test_collection_methods
    methods = %i(get)
    methods.each do |method|
      assert_respond_to @images, method
    end
  end

  def test_get_method_response
    @service.stub :get_image, @image do
      assert_instance_of Fog::Compute::AzureRM::Image, @images.get('fog-test-rg', 'fog-test-image')
    end
  end
end
