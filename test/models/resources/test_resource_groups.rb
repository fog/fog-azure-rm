require File.expand_path '../../test_helper', __dir__

# Test class for Resource Groups Collection
class TestResourceGroups < Minitest::Test
  def setup
    @service = Fog::Resources::AzureRM.new(credentials)
    @rmc_client = @service.instance_variable_get(:@rmc)
    @resource_groups = Fog::Resources::AzureRM::ResourceGroups.new(service: @service)
    @response = ApiStub::Models::Resources::ResourceGroup.create_resource_group_response(@rmc_client)
  end

  def test_collection_methods
    methods = [
      :all,
      :get,
      :check_resource_group_exists?
    ]
    methods.each do |method|
      assert_respond_to @resource_groups, method
    end
  end

  def test_all_method_response
    response = [@response]
    @service.stub :list_resource_groups, response do
      assert_instance_of Fog::Resources::AzureRM::ResourceGroups, @resource_groups.all
      assert @resource_groups.all.size >= 1
      @resource_groups.all.each do |s|
        assert_instance_of Fog::Resources::AzureRM::ResourceGroup, s
      end
    end
  end

  def test_get_method_response
    @service.stub :get_resource_group, @response do
      assert_instance_of Fog::Resources::AzureRM::ResourceGroup, @resource_groups.get('fog-test-rg')
    end
  end

  def test_check_resource_group_exists_true_response
    @service.stub :check_resource_group_exists?, true do
      assert @resource_groups.check_resource_group_exists?('fog-test-rg')
    end
  end

  def test_check_resource_group_exists_false_response
    @service.stub :check_resource_group_exists?, false do
      assert !@resource_groups.check_resource_group_exists?('fog-test-rg')
    end
  end
end
