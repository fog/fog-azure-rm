require File.expand_path '../../test_helper', __dir__

class TestVirtualNetwork < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @virtual_network = virtual_network(@service)
  end

  def test_model_methods
    response = ApiStub::Models::Network::VirtualNetwork.create_virtual_network_response
    methods = [
      :save,
      :destroy
    ]
    @service.stub :create_virtual_network, response do
      methods.each do |method|
        assert @virtual_network.respond_to? method
      end
    end
  end

  def test_model_attributes
    response = ApiStub::Models::Network::VirtualNetwork.create_virtual_network_response
    attributes = [
      :name,
      :id,
      :location,
      :dns_list,
      :subnet_address_list,
      :network_address_list,
      :resource_group
    ]
    @service.stub :create_virtual_network, response do
      attributes.each do |attribute|
        assert @virtual_network.respond_to? attribute
      end
    end
  end

  def test_save_method_response
    response = ApiStub::Models::Network::VirtualNetwork.create_virtual_network_response
    @service.stub :create_virtual_network, response do
      assert_instance_of Fog::Network::AzureRM::VirtualNetwork, @virtual_network.save
    end
  end

  def test_destroy_method_response
    response = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
    @service.stub :delete_virtual_network, response do
      assert_instance_of MsRestAzure::AzureOperationResponse, @virtual_network.destroy
    end
  end
end
