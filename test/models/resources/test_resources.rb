require File.expand_path '../../test_helper', __dir__

# Test class for Resources Collection
class TestResources < Minitest::Test
  def setup
    @service = Fog::Resources::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@rmc)
    @resources = Fog::Resources::AzureRM::AzureResources.new(service: @service, tag_name: 'tag_name', tag_value: 'tag_value')
    @response = ApiStub::Models::Resources::Resource.list_resources_response(client)
    @resource_id = '/subscriptions/########-####-####-####-############/resourceGroups/{RESOURCE-GROUP}/providers/Microsoft.Network/{PROVIDER-NAME}/{RESOURCE-NAME}'
  end

  def test_collection_methods
    methods = [
      :all,
      :get,
      :check_azure_resource_exists?
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
      assert_instance_of Fog::Resources::AzureRM::AzureResource, @resources.get(@resource_id)
      assert @resources.get('wrong-resource-id').nil?
    end
  end

  def test_check_azure_resource_exists_true_response
    @service.stub :check_azure_resource_exists?, true do
      assert @resources.check_azure_resource_exists?(@resource_id, '2016-09-01')
    end
  end

  def test_check_azure_resource_exists_false_response
    @service.stub :check_azure_resource_exists?, false do
      assert !@resources.check_azure_resource_exists?(@resource_id, '2016-09-01')
    end
  end
end
