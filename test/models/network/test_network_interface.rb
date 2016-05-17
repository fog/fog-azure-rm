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
      :virtual_machine_id,
      :mac_address,
      :network_security_group_id,
      :ip_configuration_name,
      :ip_configuration_id,
      :subnet_id,
      :private_ip_allocation_method,
      :private_ip_address,
      :public_ip_address_id,
      :load_balancer_backend_address_pools_ids,
      :load_balancer_inbound_nat_rules_ids,
      :dns_servers,
      :applied_dns_servers,
      :internal_dns_name_label,
      :internal_fqd
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
      assert_instance_of Fog::Network::AzureRM::NetworkInterface, @network_interface.save
    end
  end

  def test_destroy_method_response
    response = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
    @service.stub :delete_network_interface, response do
      assert_instance_of MsRestAzure::AzureOperationResponse, @network_interface.destroy
    end
  end
end
