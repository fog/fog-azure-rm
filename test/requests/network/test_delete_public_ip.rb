require File.expand_path '../../test_helper', __dir__

# Test class for Delete Public Ip Request
class TestDeletePublicIp < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    network_client = @service.instance_variable_get(:@network_client)
    @public_ips = network_client.public_ipaddresses
  end

  def test_delete_public_ip_success
    response = ApiStub::Requests::Network::PublicIp.delete_public_ip_response
    @public_ips.stub :delete, response do
      assert @service.delete_public_ip('fog-test-rg', 'fog-test-public-ip')
    end
  end

  def test_delete_public_ip_failure
    response = proc { raise MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @public_ips.stub :delete, response do
      assert_raises(RuntimeError) { @service.delete_public_ip('fog-test-rg', 'fog-test-public-ip') }
    end
  end
end
