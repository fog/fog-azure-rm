require File.expand_path '../../test_helper', __dir__

# Test class for Create Resource Group Request
class TestCreateResourceGroup < Minitest::Test
  def setup
    @service = Fog::Resources::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@rmc)
    @resource_groups = client.resource_groups
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_create_resource_group_success
    mocked_response = ApiStub::Requests::Resources::ResourceGroup.create_resource_group_response
    expected_response = Azure::ARM::Resources::Models::ResourceGroup.serialize_object(mocked_response.body)
    @promise.stub :value!, mocked_response do
      @resource_groups.stub :create_or_update, @promise do
        assert_equal @service.create_resource_group('fog-test-rg', 'west us'), expected_response
      end
    end
  end

  def test_create_resource_group_failure
    response = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @resource_groups.stub :create_or_update, @promise do
        assert_raises(RuntimeError) { @service.create_resource_group('fog-test-rg', 'west us') }
      end
    end
  end
end
