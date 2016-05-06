require File.expand_path '../../test_helper', __dir__

class TestNetworkInterface < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_interface = network_interface(@service)
  end

  def test_model_methods
    response = ApiStub::Models::Network::NetworkInterface.create_network_interface_response
    methods = [
      :save,
      :destroy
    ]
    @service.stub :create_network_interface, response do
      methods.each do |method|
        assert @network_interface.respond_to? method
      end
    end
  end

  def test_model_attributes
    response = ApiStub::Models::Network::NetworkInterface.create_network_interface_response
    attributes = [
      :name,
      :id,
      :location,
      :resource_group,
      :subnet_id,
      :ip_configuration_name,
      :private_ip_allocation_method,
      :properties
    ]
    @service.stub :create_network_interface, response do
      attributes.each do |attribute|
        assert @network_interface.respond_to? attribute
      end
    end
  end

  def test_save_method_response
    response = ApiStub::Models::Network::NetworkInterface.create_network_interface_response
    @service.stub :create_network_interface, response do
      assert_instance_of Azure::ARM::Network::Models::NetworkInterface, @network_interface.save
    end
  end

  def test_destroy_method_response
    response = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
    @service.stub :delete_network_interface, response do
      assert_instance_of MsRestAzure::AzureOperationResponse, @network_interface.destroy
    end
  end
end
