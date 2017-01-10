require File.expand_path '../../test_helper', __dir__

# Test class for Get Deployment Request
class TestGetDeployment < Minitest::Test
  def setup
    @service = Fog::Resources::AzureRM.new(credentials)
    @rmc_client = @service.instance_variable_get(:@rmc)
    @deployments = @rmc_client.deployments
  end

  def test_check_deployment_exists_success
    @deployments.stub :check_existence, true do
      assert @service.check_deployment_exists('fog-test-rg', 'fog-test-deployment')
    end
  end

  def test_check_deployment_exists_failure
    @deployments.stub :check_existence, false do
      assert !@service.check_deployment_exists('fog-test-rg', 'fog-test-deployment')
    end
  end

  def test_check_deployment_exists_exception
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @deployments.stub :check_existence, response do
      assert_raises(RuntimeError) { @service.check_deployment_exists('fog-test-rg', 'fog-test-deployment') }
    end
  end
end
