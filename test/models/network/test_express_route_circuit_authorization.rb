require File.expand_path '../../test_helper', __dir__

# Test class for ExpressRouteCircuitAuthorization Model
class TestExpressRouteCircuitAuthorization < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @circuit_authorization = express_route_circuit_authorization(@service)
    @network_client = @service.instance_variable_get(:@network_client)
  end

  def test_model_methods
    methods = [
      :save,
      :destroy
    ]
    methods.each do |method|
      assert @circuit_authorization.respond_to? method
    end
  end

  def test_model_attributes
    attributes = [
      :name,
      :id,
      :resource_group,
      :authorization_name,
      :authorization_key,
      :authorization_status,
      :provisioning_state,
      :etag,
      :circuit_name
    ]
    attributes.each do |attribute|
      assert @circuit_authorization.respond_to? attribute
    end
  end

  def test_save_method_response
    response = ApiStub::Models::Network::ExpressRouteCircuitAuthorization.create_express_route_circuit_authorization_response(@network_client)
    @service.stub :create_or_update_express_route_circuit_authorization, response do
      assert_instance_of Fog::Network::AzureRM::ExpressRouteCircuitAuthorization, @circuit_authorization.save
    end
  end

  def test_destroy_method_response
    @service.stub :delete_express_route_circuit_authorization, true do
      assert @circuit_authorization.destroy
    end
  end
end
