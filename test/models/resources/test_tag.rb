require File.expand_path '../../test_helper', __dir__

# Test class for Tag Model
class TestTag < Minitest::Test
  def setup
    @service = Fog::Resources::AzureRM.new(credentials)
    @tag = tag(@service)
    @response = ApiStub::Models::Resources::Tag.create_tag_response
  end

  def test_model_methods
    methods = [
      :save,
      :destroy
    ]
    methods.each do |method|
      assert @tag.respond_to? method, true
    end
  end

  def test_model_attributes
    attributes = [
      :resource_id,
      :tag_name,
      :tag_value,
      :name,
      :type,
      :location,
      :tags
    ]
    attributes.each do |attribute|
      assert @tag.respond_to? attribute, true
    end
  end

  def test_save_method_response
    @service.stub :tag_resource, @response do
      assert_instance_of Fog::Resources::AzureRM::Tag, @tag.save
    end
  end

  def test_destroy_method_response
    @service.stub :delete_resource_tag, @response do
      assert @tag.destroy('tag_name', 'tag_value')
    end
  end
end
