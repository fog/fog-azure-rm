require File.expand_path '../../test_helper', __dir__

# Test class for ExpressRouteCircuitPeering Model
class TestExpressRouteCircuitPeering < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @circuit_peering = express_route_circuit_peering(@service)
    @network_client = @service.instance_variable_get(:@network_client)
  end

  def test_model_methods
    methods = [
      :save,
      :destroy
    ]
    methods.each do |method|
      assert_respond_to @circuit_peering, method
    end
  end

  def test_model_attributes
    attributes = [
      :resource_group,
      :name,
      :circuit_name,
      :peering_type,
      :peer_asn,
      :primary_peer_address_prefix,
      :secondary_peer_address_prefix,
      :vlan_id,
      :advertised_public_prefixes,
      :advertised_public_prefix_state,
      :customer_asn,
      :routing_registry_name
    ]
    attributes.each do |attribute|
      assert_respond_to @circuit_peering, attribute
    end
  end

  def test_save_method_response
    response = ApiStub::Models::Network::ExpressRouteCircuitPeering.create_express_route_circuit_peering_response(@network_client)
    @service.stub :create_or_update_express_route_circuit_peering, response do
      assert_instance_of Fog::Network::AzureRM::ExpressRouteCircuitPeering, @circuit_peering.save
    end
  end

  def test_destroy_method_response
    @service.stub :delete_express_route_circuit_peering, true do
      assert @circuit_peering.destroy
    end
  end
end
