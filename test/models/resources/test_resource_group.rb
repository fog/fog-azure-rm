require File.expand_path '../../test_helper', __dir__

# Test class for Resource Group Model
class TestResourceGroup < Minitest::Test
  def setup
    @service = Fog::Resources::AzureRM.new(credentials)
    @resource_group = resource_group(@service)
    @response = ApiStub::Models::Resources::ResourceGroup.create_resource_group_response
  end

  def test_model_methods
    methods = [
        :save,
        :destroy
    ]
    methods.each do |method|
      assert @resource_group.respond_to? method, true
    end
  end

  def test_model_attributes
    attributes = [
        :id,
        :name,
        :location
    ]
    attributes.each do |attribute|
      assert @resource_group.respond_to? attribute, true
    end
  end

  def test_save_method_response
    @service.stub :create_resource_group, @response do
      assert_instance_of MsRestAzure::AzureOperationResponse, @resource_group.save
    end
  end

  def test_destroy_method_response
    @service.stub :delete_resource_group, @response do
      assert_instance_of MsRestAzure::AzureOperationResponse, @resource_group.destroy
    end
  end
end
