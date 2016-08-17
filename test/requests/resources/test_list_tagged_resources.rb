require File.expand_path '../../test_helper', __dir__

# Test class for List Tags Request
class TestListTags < Minitest::Test
  def setup
    @service = Fog::Resources::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@rmc)
    @resources = @client.resources
  end

  def test_list_tagged_resources_success
    mocked_response = ApiStub::Requests::Resources::AzureResource.list_tagged_resources_response(@client)
    result_mapper = Azure::ARM::Resources::Models::ResourceListResult.mapper
    expected_response = @client.serialize(result_mapper, mocked_response, 'parameters')['value']
    @resources.stub :list_as_lazy, mocked_response do
      assert_equal @service.list_tagged_resources('test_key'), expected_response
    end
  end

  def test_list_tagged_resources_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @resources.stub :list_as_lazy, response do
      assert_raises(Fog::AzureRm::OperationError) { @service.list_tagged_resources('test_key') }
    end
  end
end
