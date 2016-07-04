require File.expand_path '../../test_helper', __dir__

# Test class for Deployment Collection
class TestDeployments < Minitest::Test
  def setup
    @service = Fog::Resources::AzureRM.new(credentials)
    @deployments = Fog::Resources::AzureRM::Deployments.new(resource_group: 'fog-test-rg', service: @service)
    @response = ApiStub::Models::Resources::Deployment.list_deployments_response
  end

  def test_collection_methods
    methods = [
      :all,
      :get
    ]
    methods.each do |method|
      assert @deployments.respond_to? method, true
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
    @service.stub :list_deployments, @response do
      assert_instance_of Fog::Resources::AzureRM::Deployment, @deployments.get('fog-test-deployment')
      assert @deployments.get('wrong-name').nil?
    end
  end
end
