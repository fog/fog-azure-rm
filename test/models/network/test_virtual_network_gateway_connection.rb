require File.expand_path '../../test_helper', __dir__

# Test class for VirtualNetworkGatewayConnection Model
class TestVirtualNetworkGatewayConnection < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @gateway_connection = virtual_network_gateway_connection(@service)
    @network_client = @service.instance_variable_get(:@network_client)
  end

  def test_model_methods
    methods = [
      :save,
      :destroy
    ]
    methods.each do |method|
      assert @gateway_connection.respond_to? method
    end
  end

  def test_model_attributes
    attributes = [
      :name,
      :id,
      :location,
      :resource_group,
      :tags,
      :virtual_network_gateway1,
      :virtual_network_gateway2,
      :local_network_gateway2,
      :enable_bgp,
      :connection_type,
      :authorization_key,
      :routing_weight,
      :shared_key,
      :egress_bytes_transferred,
      :ingress_bytes_transferred,
      :peer,
      :provisioning_state,
      :connection_status
    ]
    attributes.each do |attribute|
      assert @gateway_connection.respond_to? attribute
    end
  end

  def test_save_method_response
    connection_response = ApiStub::Models::Network::VirtualNetworkGatewayConnection.create_virtual_network_gateway_connection_response(@network_client)
    @service.stub :create_or_update_virtual_network_gateway_connection, connection_response do
      assert_instance_of Fog::Network::AzureRM::VirtualNetworkGatewayConnection, @gateway_connection.save
    end
  end

  def test_destroy_method_response
    @service.stub :delete_virtual_network_gateway_connection, true do
      assert @gateway_connection.destroy
    end
  end
end
