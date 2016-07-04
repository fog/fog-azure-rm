require File.expand_path '../../test_helper', __dir__

# Test class for Delete Deployment Request
class TestDeleteDeployment < Minitest::Test
  def setup
    @service = Fog::Resources::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@rmc)
    @deployments = client.deployments
    @promise = Concurrent::Promise.execute do
    end
    @resource_group = 'fog-test-rg'
    @deployment_name = 'fog-test-deployment'
  end

  def test_delete_deployment_success
    @promise.stub :value!, true do
      @deployments.stub :delete, @promise do
        assert @service.delete_deployment(@resource_group, @deployment_name)
      end
    end
  end

  def test_list_deployment_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @deployments.stub :delete, @promise do
        assert_raises(RuntimeError) { @service.delete_deployment(@resource_group, @deployment_name) }
      end
    end
  end
end
