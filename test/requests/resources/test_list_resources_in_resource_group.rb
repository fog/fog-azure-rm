require File.expand_path '../../test_helper', __dir__

# Test class for List Resource Groups Request
class TestListResources < Minitest::Test
  def setup
    @service = Fog::Resources::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@rmc)
    @resources = @client.resource_groups
  end

  def test_list_resources_in_resource_group_success
    mocked_response = ApiStub::Requests::Resources::AzureResource.list_resources_in_resource_group(@client)
    @resources.stub :list_resources, mocked_response do
      assert_equal @service.list_resources_in_resource_group('fog-test-rg'), mocked_response
    end
  end

  def test_list_resources_in_resource_group_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @resources.stub :list_resources, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.list_resources_in_resource_group('fog-test-rg') }
    end
  end
end
