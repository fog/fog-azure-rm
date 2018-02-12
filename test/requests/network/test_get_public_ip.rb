require File.expand_path '../../test_helper', __dir__

# Test class for Get Public Ip Request
class TestGetPublicIp < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    @network_client = @service.instance_variable_get(:@network_client)
    @public_ips = @network_client.public_ipaddresses
  end

  def test_get_public_ip_success
    mocked_response = ApiStub::Requests::Network::PublicIp.create_public_ip_response(@network_client)
    @public_ips.stub :get, mocked_response do
      assert_equal @service.get_public_ip('fog-test-rg', 'fog-test-public-ip'), mocked_response
    end
  end

  def test_get_public_ip_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @public_ips.stub :get, response do
      assert_raises MsRestAzure::AzureOperationError do
        @service.get_public_ip('fog-test-rg', 'fog-test-public-ip')
      end
    end
  end
end
