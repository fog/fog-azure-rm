require File.expand_path '../../test_helper', __dir__

# Test class for List Public Ips Request
class TestListPublicIps < Minitest::Test
  def setup
    @service = Fog::Network::AzureRM.new(credentials)
    client = @service.instance_variable_get(:@network_client)
    @public_ips = client.public_ipaddresses
    @promise = Concurrent::Promise.execute do
    end
  end

  def test_list_public_ips_success
    response = ApiStub::Requests::Network::PublicIp.list_public_ips_response
    @promise.stub :value!, response do
      @public_ips.stub :list, @promise do
        assert @service.list_public_ips('fog-test-rg'), response
      end
    end
  end

  def test_list_public_ips_failure
    response = -> { fail MsRestAzure::AzureOperationError.new(nil, nil, 'error' => { 'message' => 'mocked exception' }) }
    @promise.stub :value!, response do
      @public_ips.stub :list, @promise do
        assert_raises(RuntimeError) { @service.list_public_ips('fog-test-rg') }
      end
    end
  end
end
