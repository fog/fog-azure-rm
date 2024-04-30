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
    methods = %i(all get create)
    methods.each do |method|
      assert_respond_to @images, method
    end
  end

  def test_all_method_response
    @service.stub :list_images, [@image] do
      images_list = @images.all
      assert_instance_of Fog::Compute::AzureRM::Images, images_list
      assert images_list.size >= 1
      images_list.each do |image|
        assert_instance_of Fog::Compute::AzureRM::Image, image
      end
    end
  end

  def test_get_method_response
    @service.stub :get_image, @image do
      assert_instance_of Fog::Compute::AzureRM::Image, @images.get('fog-test-rg', 'fog-test-image')
    end
  end

  def test_create_method_response
    params = {
      resource_group_name: 'fog-test-rg',
      name: 'fog-test-image',
      location: 'location',
      source_server_id: '/subscriptions/{subscription}/resourceGroups/fog-test-rg/providers/Microsoft.Compute/virtualMachines/vm-name'
    }

    @service.stub :create_image, @image do
      assert_instance_of Fog::Compute::AzureRM::Image, @images.create(params)
    end
  end
end
