require File.expand_path '../../test_helper', __dir__
# Test class for Image Model
class TestImage < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @image = image(@service)
    @compute_client = @service.instance_variable_get(:@compute_mgmt_client)
    @response = ApiStub::Models::Compute::Image.image_response(@compute_client)
  end

  def test_model_attributes
    attributes = %i(
      id
      name
      resource_group_name
      location
      provisioning_state
      source_server_id
      source_server_name
      managed_disk_id
      os_disk_size
      os_disk_state
      os_disk_type
      os_disk_caching
      os_disk_blob_uri
      tags
    )
    attributes.each do |attribute|
      assert_respond_to @image, attribute
    end
  end

  def test_collection_methods
    methods = %i(destroy save)
    methods.each do |method|
      assert_respond_to @image, method
    end
  end

  def test_parse_method
    snap_hash = Fog::Compute::AzureRM::Image.parse(@response)
    @response.instance_variables.each do |attribute|
      assert_equal @response.instance_variable_get(attribute), snap_hash[attribute.to_s.delete('@')]
    end
  end

  def test_destroy_method_response
    @service.stub :delete_image, true do
      assert @image.destroy
    end
  end

  def test_save_method_response
    @service.stub :create_image, @response do
      assert_instance_of Fog::Compute::AzureRM::Image, @image.save
    end
  end
end
