require File.expand_path '../../test_helper', __dir__

# Test class for ExpressRouteCircuit Collection
class TestExpressRouteCircuits < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @circuits = Fog::Network::AzureRM::ExpressRouteCircuits.new(resource_group: 'fog-test-rg', service: @service)
    @network_client = @service.instance_variable_get(:@network_client)
  end

  def test_collection_methods
    methods = [
      :all,
      :get
    ]
    methods.each do |method|
      assert_respond_to @circuits, method
    end
  end

  def test_collection_attributes
    assert_respond_to @circuits, :resource_group
  end

  def test_all_method_response
    response = [ApiStub::Models::Network::ExpressRouteCircuit.create_express_route_circuit_response(@network_client)]
    @service.stub :list_express_route_circuits, response do
      assert_instance_of Fog::Network::AzureRM::ExpressRouteCircuits, @circuits.all
      assert @circuits.all.size >= 1
      @circuits.all.each do |circuit|
        assert_instance_of Fog::Network::AzureRM::ExpressRouteCircuit, circuit
      end
    end
  end

  def test_get_method_response
    response = ApiStub::Models::Network::ExpressRouteCircuit.create_express_route_circuit_response(@network_client)
    @service.stub :get_express_route_circuit, response do
      assert_instance_of Fog::Network::AzureRM::ExpressRouteCircuit, @circuits.get('HaiderRG', 'testCircuit')
    end
  end
end
