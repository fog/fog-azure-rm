require File.expand_path '../../test_helper', __dir__

# Test class for Get Resource Group Request
class TestGetResourceGroup < Minitest::Test
  def setup
    @service = Fog::Resources::AzureRM.new(credentials)
    @rmc_client = @service.instance_variable_get(:@rmc)
    @resource_groups = @rmc_client.resource_groups
  end

  def test_check_resource_group_exists_success
    @resource_groups.stub :check_existence, true do
      assert @service.check_resource_group_exists('fog-test-rg')
    end
  end

  def test_check_resource_group_exists_failure
    @resource_groups.stub :check_existence, false do
      assert !@service.check_resource_group_exists('fog-test-rg')
    end
  end

  def test_check_resource_group_exists_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @resource_groups.stub :check_existence, response do
      assert_raises(MsRestAzure::AzureOperationError) { @service.check_resource_group_exists('fog-test-rg') }
    end
  end
end
