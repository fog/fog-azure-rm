require File.expand_path '../../test_helper', __dir__

# Test class for Delete Resource Group Request
class TestDeleteResourceGroup < Minitest::Test
  def setup
    @service = Fog::Resources::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@rmc)
    @resource_groups = client.resource_groups
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_delete_resource_group_success
    response = ApiStub::Requests::Resources::ResourceGroup.create_resource_group_response
    @promise.stub :value!, response do
      @resource_groups.stub :delete, @promise do
        assert @service.delete_resource_group('fog-test-rg')
      end
    end
  end

  def test_delete_resource_group_failure
    response = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @resource_groups.stub :delete, @promise do
        assert_raises(RuntimeError) { @service.delete_resource_group('fog-test-rg') }
      end
    end
  end
end
