require File.expand_path '../../test_helper', __dir__

# Test class for Tags Collection
class TestTags < Minitest::Test
  def setup
    @service = Fog::Resources::AzureRM.new(credentials)
    @tags = Fog::Resources::AzureRM::Tags.new(service: @service, tag_name: 'tag_name')
    @response = ApiStub::Models::Resources::Tag.list_tags_response
  end

  def test_collection_methods
    methods = [
      :all,
      :get
    ]
    methods.each do |method|
      assert @tags.respond_to? method, true
    end
  end

  def test_all_method_response
    @service.stub :list_tagged_resources, @response do
      assert_instance_of Fog::Resources::AzureRM::Tags, @tags.all
      assert @tags.all.size >= 1
      @tags.all.each do |s|
        assert_instance_of Fog::Resources::AzureRM::Tag, s
      end
    end
  end

  def test_get_method_response
    @service.stub :list_tagged_resources, @response do
      resource_id = '/subscriptions/########-####-####-####-############/resourceGroups/{RESOURCE-GROUP}/providers/Microsoft.Network/{PROVIDER-NAME}/{RESOURCE-NAME}'
      assert_instance_of Fog::Resources::AzureRM::Tag, @tags.get(resource_id)
      assert @tags.get('wrong-resource-id').nil?
    end
  end
end
