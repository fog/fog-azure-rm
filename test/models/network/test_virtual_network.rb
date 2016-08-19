require File.expand_path '../../test_helper', __dir__

# Test class for VirtualNetwork Model
class TestVirtualNetwork < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @virtual_network = virtual_network(@service)
    @client = @service.instance_variable_get(:@network_client)
  end

  def test_model_methods
    methods = [
      :save,
      :add_dns_servers,
      :remove_dns_servers,
      :add_address_prefixes,
      :remove_address_prefixes,
      :add_subnets,
      :remove_subnets,
      :update,
      :destroy
    ]
    methods.each do |method|
      assert @virtual_network.respond_to? method
    end
  end

  def test_model_attributes
    attributes = [
      :name,
      :id,
      :location,
      :dns_servers,
      :subnets,
      :address_prefixes,
      :resource_group
    ]
    attributes.each do |attribute|
      assert @virtual_network.respond_to? attribute
    end
  end

  def test_save_method_response
    response = ApiStub::Models::Network::VirtualNetwork.create_virtual_network_response(@client)
    @service.stub :create_or_update_virtual_network, response do
      assert_instance_of Fog::Network::AzureRM::VirtualNetwork, @virtual_network.save
    end
  end

  def test_add_dns_servers_method_response
    response = ApiStub::Models::Network::VirtualNetwork.create_virtual_network_response(@client)
    @service.stub :add_dns_servers_in_virtual_network, response do
      assert_instance_of Fog::Network::AzureRM::VirtualNetwork, @virtual_network.add_dns_servers(['10.3.0.0', '10.4.0.0'])
    end
  end

  def test_remove_dns_servers_method_response
    response = ApiStub::Models::Network::VirtualNetwork.create_virtual_network_response(@client)
    @service.stub :remove_dns_servers_from_virtual_network, response do
      assert_instance_of Fog::Network::AzureRM::VirtualNetwork, @virtual_network.remove_dns_servers(['10.3.0.0', '10.4.0.0'])
    end
  end

  def test_add_address_prefixes_method_response
    response = ApiStub::Models::Network::VirtualNetwork.create_virtual_network_response(@client)
    @service.stub :add_address_prefixes_in_virtual_network, response do
      assert_instance_of Fog::Network::AzureRM::VirtualNetwork, @virtual_network.add_address_prefixes(['10.0.0.0/16'])
    end
  end

  def test_remove_address_prefixes_method_response
    response = ApiStub::Models::Network::VirtualNetwork.create_virtual_network_response(@client)
    @service.stub :remove_address_prefixes_from_virtual_network, response do
      assert_instance_of Fog::Network::AzureRM::VirtualNetwork, @virtual_network.remove_address_prefixes(['10.0.0.0/16'])
    end
  end

  def test_add_subnets_method_response
    subnets = [{
      name: 'test-subnet',
      address_prefix: '10.0.0.0/16'
    }]
    response = ApiStub::Models::Network::VirtualNetwork.create_virtual_network_response(@client)
    @service.stub :add_subnets_in_virtual_network, response do
      assert_instance_of Fog::Network::AzureRM::VirtualNetwork, @virtual_network.add_subnets(subnets)
    end
  end

  def test_remove_subnets_method_response
    response = ApiStub::Models::Network::VirtualNetwork.create_virtual_network_response(@client)
    @service.stub :remove_subnets_from_virtual_network, response do
      assert_instance_of Fog::Network::AzureRM::VirtualNetwork, @virtual_network.remove_subnets(['test-subnet'])
    end
  end

  def test_update_method_response
    subnets = [{
      name: 'test-subnet',
      address_prefix: '10.0.0.0/16'
    }]
    response = ApiStub::Models::Network::VirtualNetwork.create_virtual_network_response(@client)
    @service.stub :create_or_update_virtual_network, response do
      assert_instance_of Fog::Network::AzureRM::VirtualNetwork, @virtual_network.update(subnets: subnets, address_prefixes: ['10.0.0.0/16'])
    end
  end

  def test_destroy_method_response
    response = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
    @service.stub :delete_virtual_network, response do
      assert_instance_of MsRestAzure::AzureOperationResponse, @virtual_network.destroy
    end
  end
end
