require File.expand_path '../../test_helper', __dir__

# Test class for List Resource Groups Request
class TestListResourceGroups < Minitest::Test
  def setup
    @service = Fog::Resources::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@rmc)
    @resource_groups = @client.resource_groups
  end

  def test_list_resource_group_success
    mocked_response = ApiStub::Requests::Resources::ResourceGroup.list_resource_group_response(@client)
    @resource_groups.stub :list_as_lazy, mocked_response do
      assert_equal @service.list_resource_groups, mocked_response.value
    end
  end

  def test_list_resource_group_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @resource_groups.stub :list_as_lazy, response do
      assert_raises(RuntimeError) { @service.list_resource_groups }
    end
  end
end
