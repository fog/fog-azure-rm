require File.expand_path '../../test_helper', __dir__

# Test class for List Tags Request
class TestListTags < Minitest::Test
  def setup
    @service = Fog::Resources::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@rmc)
    @tags = client.resources
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_list_tagged_resources_success
    mokced_response = ApiStub::Requests::Resources::Tag.list_tagged_resources_response
    expected_response = Azure::ARM::Resources::Models::ResourceListResult.serialize_object(mokced_response.body)['value']
    @promise.stub :value!, mokced_response do
      @tags.stub :list, @promise do
        assert_equal @service.list_tagged_resources('test_key'), expected_response
      end
    end
  end

  def test_list_tagged_resources_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @tags.stub :list, @promise do
        assert_raises(RuntimeError) { @service.list_tagged_resources('test_key') }
      end
    end
  end
end
