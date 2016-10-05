require File.expand_path '../../test_helper', __dir__

# Test class for Deployment Collection
class TestDeployments < Minitest::Test
  def setup
    @service = Fog::Resources::AzureRM.new(credentials)
    @rmc_client = @service.instance_variable_get(:@rmc)
    @deployments = Fog::Resources::AzureRM::Deployments.new(resource_group: 'fog-test-rg', service: @service)
    @response = ApiStub::Models::Resources::Deployment.list_deployments_response(@rmc_client)
  end

  def test_collection_methods
    methods = [
      :all,
      :get
    ]
    methods.each do |method|
      assert_respond_to @deployments, method
    end
  end

  def test_all_method_response
    @service.stub :list_deployments, @response do
      assert_instance_of Fog::Resources::AzureRM::Deployments, @deployments.all
      assert @deployments.all.size >= 1
      @deployments.all.each do |deployment|
        assert_instance_of Fog::Resources::AzureRM::Deployment, deployment
      end
    end
  end

  def test_get_method_response
    response = ApiStub::Models::Resources::Deployment.create_deployment_response(@rmc_client)
    @service.stub :get_deployment, response do
      assert_instance_of Fog::Resources::AzureRM::Deployment, @deployments.get('fog-test-rg', 'fog-test-deployment')
    end
  end
end
