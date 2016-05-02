require File.expand_path '../../test_helper', __dir__

class TestPublicIp < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @public_ip = public_ip(@service)
  end

  def test_model_methods
    response = ApiStub::Models::Network::PublicIp.create_public_ip_response
    methods = [
      :save,
      :destroy
    ]
    @service.stub :create_public_ip, response do
      methods.each do |method|
        assert @public_ip.respond_to? method
      end
    end
  end

  def test_model_attributes
    response = ApiStub::Models::Network::PublicIp.create_public_ip_response
    attributes = [
      :name,
      :type,
      :location,
      :resource_group
    ]
    @service.stub :create_public_ip, response do
      attributes.each do |attribute|
        assert @public_ip.respond_to? attribute
      end
    end
  end

  def test_save_method_response
    response = ApiStub::Models::Network::PublicIp.create_public_ip_response
    @service.stub :create_public_ip, response do
      assert_instance_of Azure::ARM::Network::Models::PublicIPAddress, @public_ip.save
    end
  end

  def test_destroy_method_response
    response = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
    @service.stub :delete_public_ip, response do
      assert_instance_of MsRestAzure::AzureOperationResponse, @public_ip.destroy
    end
  end
end
