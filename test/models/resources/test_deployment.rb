require File.expand_path '../../test_helper', __dir__

# Test class for Deployment Model
class TestDeployment < Minitest::Test
  def setup
    @service = Fog::Resources::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@rmc)
    @deployment = deployment(@service)
    @response = ApiStub::Models::Resources::Deployment.create_deployment_response(client)
  end

  def test_model_methods
    methods = [
      :save,
      :destroy
    ]
    methods.each do |method|
      assert @deployment.respond_to? method, true
    end
  end

  def test_model_attributes
    attributes = [
      :name,
      :id,
      :resource_group,
      :correlation_id,
      :timestamp,
      :outputs,
      :providers,
      :dependencies,
      :template_link,
      :parameters_link,
      :mode,
      :debug_setting,
      :content_version,
      :provisioning_state
    ]
    attributes.each do |attribute|
      assert @deployment.respond_to? attribute, true
    end
  end

  def test_save_method_response
    @service.stub :create_deployment, @response do
      assert_instance_of Fog::Resources::AzureRM::Deployment, @deployment.save
    end
  end

  def test_destroy_method_response
    @service.stub :delete_deployment, @response do
      assert @deployment.destroy
    end
  end
end
