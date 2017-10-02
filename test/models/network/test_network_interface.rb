require File.expand_path '../../test_helper', __dir__

# Test class for NetworkInterface Model
class TestNetworkInterface < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_interface = network_interface(@service)
    network_client = @service.instance_variable_get(:@network_client)
    @response = ApiStub::Models::Network::NetworkInterface.create_network_interface_response(network_client)
  end

  def test_model_methods
    methods = [
      :save,
      :destroy,
      :attach_subnet,
      :attach_public_ip,
      :attach_network_security_group,
      :detach_public_ip,
      :detach_network_security_group
    ]
    methods.each do |method|
      assert_respond_to @network_interface, method
    end
  end

  def test_model_attributes
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
      :internal_fqd,
      :tags
    ]
    attributes.each do |attribute|
      assert_respond_to @network_interface, attribute
    end
  end

  def test_save_method_response
    @service.stub :create_or_update_network_interface, @response do
      assert_instance_of Fog::Network::AzureRM::NetworkInterface, @network_interface.save
    end
  end

  def test_destroy_method_response
    response = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
    @service.stub :delete_network_interface, response do
      assert_instance_of MsRestAzure::AzureOperationResponse, @network_interface.destroy
    end
  end

  def test_attach_subnet
    @service.stub :attach_resource_to_nic, @response do
      assert_instance_of Fog::Network::AzureRM::NetworkInterface, @network_interface.attach_subnet('<subnet-id>')
    end
  end

  def test_attach_public_ip
    @service.stub :attach_resource_to_nic, @response do
      assert_instance_of Fog::Network::AzureRM::NetworkInterface, @network_interface.attach_public_ip('<public-ip-id>')
    end
  end

  def test_attach_network_security_group
    @service.stub :attach_resource_to_nic, @response do
      assert_instance_of Fog::Network::AzureRM::NetworkInterface, @network_interface.attach_network_security_group('<nsg-id>')
    end
  end

  def test_detach_public_ip
    @service.stub :detach_resource_from_nic, @response do
      assert_instance_of Fog::Network::AzureRM::NetworkInterface, @network_interface.detach_public_ip
    end
  end

  def test_detach_network_security_group
    @service.stub :detach_resource_from_nic, @response do
      assert_instance_of Fog::Network::AzureRM::NetworkInterface, @network_interface.detach_network_security_group
    end
  end
end
