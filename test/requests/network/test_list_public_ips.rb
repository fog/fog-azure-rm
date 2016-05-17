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
    mocked_response = ApiStub::Requests::Network::PublicIp.list_public_ips_response
    expected_response = Azure::ARM::Network::Models::PublicIPAddressListResult.serialize_object(mocked_response.body)
    @promise.stub :value!, mocked_response do
      @public_ips.stub :list, @promise do
        assert_equal @service.list_public_ips('fog-test-rg'), expected_response['value']
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
