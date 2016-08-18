require File.expand_path '../../test_helper', __dir__

# Test class for Resource Groups Collection
class TestResourceGroups < Minitest::Test
  def setup
    @service = Fog::Resources::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@rmc)
    @resource_groups = Fog::Resources::AzureRM::ResourceGroups.new(service: @service)
    @response = [ApiStub::Models::Resources::ResourceGroup.create_resource_group_response(client)]
  end

  def test_collection_methods
    methods = [
      :all,
      :get
    ]
    methods.each do |method|
      assert @resource_groups.respond_to? method, true
    end
  end

  def test_all_method_response
    @service.stub :list_resource_groups, @response do
      assert_instance_of Fog::Resources::AzureRM::ResourceGroups, @resource_groups.all
      assert @resource_groups.all.size >= 1
      @resource_groups.all.each do |s|
        assert_instance_of Fog::Resources::AzureRM::ResourceGroup, s
      end
    end
  end

  def test_get_method_response
    @service.stub :list_resource_groups, @response do
      assert_instance_of Fog::Resources::AzureRM::ResourceGroup, @resource_groups.get('fog-test-rg')
      assert @resource_groups.get('wrong-name').nil?
    end
  end
end
