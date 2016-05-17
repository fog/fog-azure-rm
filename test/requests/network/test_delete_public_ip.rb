require File.expand_path '../../test_helper', __dir__

# Test class for Delete Public Ip Request
class TestDeletePublicIp < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @public_ips = client.public_ipaddresses
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_delete_public_ip_success
    response = ApiStub::Requests::Network::PublicIp.delete_public_ip_response
    @promise.stub :value!, response do
      @public_ips.stub :delete, @promise do
        assert @service.delete_public_ip('fog-test-rg', 'fog-test-public-ip')
      end
    end
  end

  def test_delete_public_ip_failure
    response = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @public_ips.stub :delete, @promise do
        assert_raises(RuntimeError) { @service.delete_public_ip('fog-test-rg', 'fog-test-public-ip') }
      end
    end
  end
end
