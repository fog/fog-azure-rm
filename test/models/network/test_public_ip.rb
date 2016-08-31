require File.expand_path '../../test_helper', __dir__

# Test class for PublicIp Model
class TestPublicIp < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @public_ip = public_ip(@service)
  end

  def test_model_methods
    methods = [
      :save,
      :destroy,
      :update
    ]
    methods.each do |method|
      assert @public_ip.respond_to? method
    end
  end

  def test_model_attributes
    attributes = [
      :name,
      :id,
      :location,
      :resource_group,
      :ip_address,
      :public_ip_allocation_method,
      :idle_timeout_in_minutes,
      :ip_configuration_id,
      :domain_name_label,
      :fqdn,
      :reverse_fqdn
    ]
    attributes.each do |attribute|
      assert @public_ip.respond_to? attribute
    end
  end

  def test_save_method_response
    response = ApiStub::Models::Network::PublicIp.create_public_ip_response(@network_client)
    @service.stub :create_or_update_public_ip, response do
      assert_instance_of Fog::Network::AzureRM::PublicIp, @public_ip.save
    end
  end

  def test_update_method_response
    response = ApiStub::Models::Network::PublicIp.create_public_ip_response(@network_client)
    @service.stub :create_or_update_public_ip, response do
      assert_instance_of Fog::Network::AzureRM::PublicIp, @public_ip.update({})
    end
  end

  def test_destroy_method_response
    response = MsRestAzure::AzureOperationResponse.new(MsRest::HttpOperationRequest.new('', '', ''), Faraday::Response.new)
    @service.stub :delete_public_ip, response do
      assert_instance_of MsRestAzure::AzureOperationResponse, @public_ip.destroy
    end
  end
end
