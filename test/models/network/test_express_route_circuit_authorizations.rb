require File.expand_path '../../test_helper', __dir__

# Test class for ExpressRouteCircuitAuthorizations Collection
class TestExpressRouteCircuitAuthorizations < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @circuit_authorizations = Fog::Network::AzureRM::ExpressRouteCircuitAuthorizations.new(resource_group: 'fog-test-rg', circuit_name: 'testCircuit', service: @service)
    @network_client = @service.instance_variable_get(:@network_client)
  end

  def test_collection_methods
    methods = [
      :all,
      :get
    ]
    methods.each do |method|
      assert @circuit_authorizations.respond_to? method
    end
  end

  def test_collection_attributes
    assert @circuit_authorizations.respond_to? :resource_group
    assert @circuit_authorizations.respond_to? :circuit_name
  end

  def test_all_method_response
    response = [ApiStub::Models::Network::ExpressRouteCircuitAuthorization.create_express_route_circuit_authorization_response(@network_client)]
    @service.stub :list_express_route_circuit_authorizations, response do
      assert_instance_of Fog::Network::AzureRM::ExpressRouteCircuitAuthorizations, @circuit_authorizations.all
      assert @circuit_authorizations.all.size >= 1
      @circuit_authorizations.all.each do |circuit_authorization|
        assert_instance_of Fog::Network::AzureRM::ExpressRouteCircuitAuthorization, circuit_authorization
      end
    end
  end

  def test_get_method_response
    response = ApiStub::Models::Network::ExpressRouteCircuitAuthorization.create_express_route_circuit_authorization_response(@network_client)
    @service.stub :get_express_route_circuit_authorization, response do
      assert_instance_of Fog::Network::AzureRM::ExpressRouteCircuitAuthorization, @circuit_authorizations.get('HaiderRG', 'testCircuit', 'auth-name')
    end
  end
end
