require File.expand_path '../../test_helper', __dir__

# Test class for List Deployment Request
class TestListDeployment < Minitest::Test
  def setup
    @service = Fog::Resources::AzureRM.new(credentials)
    @client = @service.instance_variable_get(:@rmc)
    @deployments = @client.deployments
    @resource_group = 'fog-test-rg'
  end

  def test_list_deployment_success
    mocked_response = ApiStub::Requests::Resources::Deployment.list_deployment_response(@client)
    result_mapper = Azure::ARM::Resources::Models::DeploymentListResult.mapper
    expected_response = @client.serialize(result_mapper, mocked_response, 'parameters')['value']
    @deployments.stub :list_as_lazy, mocked_response do
      assert_equal @service.list_deployments(@resource_group), expected_response
    end
  end

  def test_list_deployment_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @deployments.stub :list_as_lazy, response do
      assert_raises(Fog::AzureRm::OperationError) { @service.list_deployments(@resource_group) }
    end
  end
end
