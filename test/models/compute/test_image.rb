require File.expand_path '../../test_helper', __dir__
# Test class for Image Model
class TestImage < Minitest::Test
  def setup
    @service = Fog::Compute::AzureRM.new(credentials)
    @image = image(@service)
    compute_client = @service.instance_variable_get(:@compute_mgmt_client)
    @response = ApiStub::Requests::Compute::Image.create_image(compute_client)
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
end
