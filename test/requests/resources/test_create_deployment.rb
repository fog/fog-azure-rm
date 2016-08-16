require File.expand_path '../../test_helper', __dir__

# Test class for Create Deployment Request
class TestCreateDeployment < Minitest::Test
  def setup
    @service = Fog::Resources::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@rmc)
    @deployments = client.deployments
    @resource_group = 'fog-test-rg'
    @deployment_name = 'fog-test-deployment'
    @template_link = 'https://test.com/template.json'
    @parameters_link = 'https://test.com/parameters.json'
  end

  def test_create_deployment_success
    validate_deployment_promise = Concurrent::Promise.execute do
    end
    create_deployment_promise = Concurrent::Promise.execute do
    end
    mocked_response = ApiStub::Requests::Resources::Deployment.create_deployment_response
    expected_response = Azure::ARM::Resources::Models::DeploymentExtended.serialize_object(mocked_response.body)
    validate_deployment_promise.stub :value!, true do
      @deployments.stub :validate, validate_deployment_promise do
        create_deployment_promise.stub :value!, mocked_response do
          @deployments.stub :create_or_update, create_deployment_promise do
            assert_equal @service.create_deployment(@resource_group, @deployment_name, @template_link, @parameters_link), expected_response
          end
        end
      end
    end
  end

  def test_create_deployment_failure
    validate_deployment_promise = Concurrent::Promise.execute do
    end
    create_deployment_promise = Concurrent::Promise.execute do
    end
    response = -> { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    validate_deployment_promise.stub :value!, true do
      @deployments.stub :validate, validate_deployment_promise do
        create_deployment_promise.stub :value!, response do
          @deployments.stub :create_or_update, create_deployment_promise do
            assert_raises(Fog::AzureRm::OperationError) { @service.create_deployment(@resource_group, @deployment_name, @template_link, @parameters_link) }
          end
        end
      end
    end
  end
end
