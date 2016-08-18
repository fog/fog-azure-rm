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
    @resources.stub :list_as_lazy, mocked_response do
      assert_equal @service.list_tagged_resources('test_key'), mocked_response.value
    end
  end

  def test_list_tagged_resources_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @resources.stub :list_as_lazy, response do
      assert_raises(RuntimeError) { @service.list_tagged_resources('test_key') }
    end
  end
end
