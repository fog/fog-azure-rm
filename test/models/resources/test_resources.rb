require File.expand_path '../../test_helper', __dir__

# Test class for Resources Collection
class TestResources < Minitest::Test
  def setup
    @service = Fog::Resources::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@rmc)
    @resources = Fog::Resources::AzureRM::AzureResources.new(service: @service, tag_name: 'tag_name', tag_value: 'tag_value')
    @response = ApiStub::Models::Resources::Resource.list_resources_response(client)
  end

  def test_collection_methods
    methods = [
      :all,
      :get
    ]
    methods.each do |method|
      assert_respond_to @resources, method
    end
  end

  def test_all_method_response
    @service.stub :list_tagged_resources, @response do
      assert_instance_of Fog::Resources::AzureRM::AzureResources, @resources.all
      assert @resources.all.size >= 1
      @resources.all.each do |r|
        assert_instance_of Fog::Resources::AzureRM::AzureResource, r
      end
    end
  end

  def test_get_method_response
    @service.stub :list_tagged_resources, @response do
      resource_id = '/subscriptions/########-####-####-####-############/resourceGroups/{RESOURCE-GROUP}/providers/Microsoft.Network/{PROVIDER-NAME}/{RESOURCE-NAME}'
      assert_instance_of Fog::Resources::AzureRM::AzureResource, @resources.get(resource_id)
      assert @resources.get('wrong-resource-id').nil?
    end
  end
end
