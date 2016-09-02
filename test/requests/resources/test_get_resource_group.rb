require File.expand_path '../../test_helper', __dir__

# Test class for Get Resource Group Request
class TestGetResourceGroup < Minitest::Test
  def setup
    @service = Fog::Resources::AzureRM.new(credentials)
    @rmc_client = @service.instance_variable_get(:@rmc)
    @resource_groups = @rmc_client.resource_groups
  end

  def test_get_resource_group_success
    mocked_response = ApiStub::Requests::Resources::ResourceGroup.create_resource_group_response(@rmc_client)
    @resource_groups.stub :get, mocked_response do
      assert_equal @service.get_resource_group('fog-test-rg'), mocked_response
    end
  end

  def test_get_resource_group_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @resource_groups.stub :get, response do
      assert_raises(RuntimeError) { @service.get_resource_group('fog-test-rg') }
    end
  end
end
