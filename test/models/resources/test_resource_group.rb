require File.expand_path '../../test_helper', __dir__

# Test class for Resource Group Model
class TestResourceGroup < Minitest::Test
  def setup
    @service = Fog::Resources::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@rmc)
    @resource_group = resource_group(@service)
    @response = ApiStub::Models::Resources::ResourceGroup.create_resource_group_response(client)
  end

  def test_model_methods
    methods = [
      :save,
      :destroy
    ]
    methods.each do |method|
      assert_respond_to @resource_group, method
    end
  end

  def test_model_attributes
    attributes = [
      :id,
      :name,
      :location
    ]
    attributes.each do |attribute|
      assert_respond_to @resource_group, attribute
    end
  end

  def test_save_method_response
    @service.stub :create_resource_group, @response do
      assert_instance_of Fog::Resources::AzureRM::ResourceGroup, @resource_group.save
    end
  end

  def test_destroy_method_response
    @service.stub :delete_resource_group, @response do
      assert @resource_group.destroy
    end
  end
end
