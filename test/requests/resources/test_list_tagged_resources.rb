require File.expand_path '../../test_helper', __dir__

# Test class for List Tags Request
class TestListTags < Minitest::Test
  def setup
    @service = Fog::Resources::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@rmc)
    @resources = @client.resources
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_list_tagged_resources_success
    mocked_response = ApiStub::Requests::Resources::AzureResource.list_tagged_resources_response(@client)
    result_mapper = Azure::ARM::Resources::Models::ResourceListResult.mapper
    expected_response = @client.serialize(result_mapper, mocked_response.body, 'parameters')['value']
    @promise.stub :value!, mocked_response do
      @resources.stub :list, @promise do
        assert_equal @service.list_tagged_resources('test_key'), expected_response
      end
    end
  end

  def test_list_tagged_resources_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @resources.stub :list, @promise do
        assert_raises(RuntimeError) { @service.list_tagged_resources('test_key') }
      end
    end
  end
end
