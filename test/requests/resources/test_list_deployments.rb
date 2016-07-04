require File.expand_path '../../test_helper', __dir__

# Test class for List Deployment Request
class TestListDeployment < Minitest::Test
  def setup
    @service = Fog::Resources::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@rmc)
    @deployments = client.deployments
    @promise = Concurrent::Promise.execute do
    end
    @resource_group = 'fog-test-rg'
  end

  def test_list_deployment_success
    mocked_response = ApiStub::Requests::Resources::Deployment.list_deployment_response
    expected_response = Azure::ARM::Resources::Models::DeploymentListResult.serialize_object(mocked_response.body)['value']
    @promise.stub :value!, mocked_response do
      @deployments.stub :list, @promise do
        assert_equal @service.list_deployments(@resource_group), expected_response
      end
    end
  end

  def test_list_deployment_failure
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @deployments.stub :list, @promise do
        assert_raises(RuntimeError) { @service.list_deployments(@resource_group) }
      end
    end
  end
end
